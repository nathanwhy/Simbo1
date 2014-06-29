//
//  DetailViewController.m
//  Simbo1
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "DetailViewController.h"
#import "StatusDetailCell.h"
#import "StatusTool.h"
#import "DetailFrame.h"
#import "HeadImage.h"
#import "Status.h"
#import "HeadButtonDock.h"
#import "BaseText.h"
#import "BaseTextCell.h"
#import "BaseTextCellFrame.h"
#import "Comment.h"
#import "PhotoBowserViewController.h"

@interface DetailViewController ()<StatuesDetailCellDelegate,HeadButtonDelegate>
{
    DetailFrame *_detailFrame;
    NSMutableArray *_repostFrames; // 转发frame数据
    NSMutableArray *_commentFrames; // 评论frame数据
    
    HeadButtonDock *_headButtonDock;
    HeadImage *_detailHeader;
    
    PhotoBowserViewController *_photoVC;//图片浏览
}
@end

@implementation DetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"微博正文";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _detailFrame = [[DetailFrame alloc] init];
    _detailFrame.status = _status;
    
    _repostFrames = [NSMutableArray array];
    _commentFrames = [NSMutableArray array];
    
    
    //创建section的head（评论，转发，赞）
    HeadButtonDock *headButtonDock = [[HeadButtonDock alloc] init];
    headButtonDock.delegate = self;
    _headButtonDock = headButtonDock;
    
    //默认点击了评论
    [self HeadButtonDock:nil btnClick:kHeadButtonTypeComment];
    

    //打开图片视图通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPhoto:) name:@"openPhotoNotification" object:nil];
    
}


#pragma mark -------table view数据源---------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {//微博详情
        static NSString *CellIdentifier = @"DetailCell";
        StatusDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[StatusDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
        }
        cell.StatusCellFrame = _detailFrame;
        
        cell.delegate = self;
        return cell;
        
    }else if (_headButtonDock.currentBtnType == kHeadButtonTypeRepost)
    {//转发详情
        static NSString *CellIdentifier = @"RepostCell";
        BaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.cellFrame = _repostFrames[indexPath.row];
        return cell;
        
    }else
    {// 评论cell
        static NSString *CellIdentifier = @"CommentCell";
        BaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.cellFrame = _commentFrames[indexPath.row];
        return cell;
    }

}


#pragma mark section和row的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(_headButtonDock.currentBtnType == kHeadButtonTypeComment){
        return _commentFrames.count;
    }else{
        return _repostFrames.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _detailFrame.cellHeight;
    }else if(_headButtonDock.currentBtnType == kHeadButtonTypeComment){
        return [_commentFrames[indexPath.row] cellHeight];
    }else{
        return [_repostFrames[indexPath.row] cellHeight];
    }
}

#pragma mark 判断第indexPath行的cell能不能达到选中状态
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_status.retweetedStatus !=nil) {
        return YES;
    }
    return NO;
}

#pragma mark 展示转发微博
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StatusDetailCell *cell=(StatusDetailCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self statuesDetailCellPushToRetweet:cell];
    }
    
}

#pragma mark 展示转发微博的代理方法实现
- (void)statuesDetailCellPushToRetweet:(StatusDetailCell *)DetailCell
{
    
    if (_status.retweetedStatus) {
        DetailViewController *retweetVC = [[DetailViewController alloc] init];
        StatusCellFrame *f = DetailCell.statusCellFrame;
        retweetVC.status = f.status.retweetedStatus;
        
        [self.navigationController pushViewController:retweetVC animated:YES];
    }
    
}

#pragma mark 设置headView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1? kButtonH: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    _headButtonDock.status =_status;
    return _headButtonDock;
}

#pragma mark HeadButton的代理方法
- (void)HeadButtonDock:(HeadButtonDock *)header btnClick:(HeadButtonType )index
{
    //先展示旧的数据
    //[self.tableView reloadData];
    
    if (index == kHeadButtonTypeRepost) {
        
        long long sinceID = _repostFrames.count?[[_repostFrames[0] baseText]ID]:0;
        [StatusTool repostsWithSinceId:sinceID maxId:0 statusId:_status.ID success:^(NSArray *reposts, int totalNumber, long long nextCursor) {
            
            NSMutableArray *newFrames = [NSMutableArray array];
            // 1.解析最新的转发frame数据
            for (Comment *s in reposts) {
                 BaseTextCellFrame *f = [[BaseTextCellFrame alloc] init];
                 f.baseText = s;
                 [newFrames addObject:f];
                
                
            }
            _status.repostsCount = totalNumber;
            

            // 2.添加数据
            [_repostFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
            
            
            // 3.刷新表格
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
        
    }else if (index == kHeadButtonTypeComment){
        
        
        long long sinceID = _commentFrames.count?[[_commentFrames[0] baseText]ID]:0;
       
        [StatusTool commentsWithSinceId:sinceID maxId:0 statusId:_status.ID success:^(NSArray *comments, int totalNumber, long long nextCursor) {
            NSMutableArray *newFrames = [NSMutableArray array];
            // 1.解析最新的转发frame数据
            for (BaseText *s in comments) {
                BaseTextCellFrame *f = [[BaseTextCellFrame alloc] init];
                f.baseText = s;
                [newFrames addObject:f];
                
            }
            _status.commentsCount = totalNumber;
            
            // 2.添加数据
            [_commentFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
            
            // 3.刷新表格
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"failed");
        }];
        
    }
}


#pragma mark - 显示照片浏览器
- (void) openPhoto:(NSNotification *)notification
{
    if (self.navigationController.topViewController != self) return;
    
    //取出字典
    NSDictionary *dic = [notification object];
    NSInteger currentIndex = [dic[@"currentIndex"] intValue];
    
    if (_photoVC == nil) {
        _photoVC = [[PhotoBowserViewController alloc] init];
    }
    
    Status *data =_status;
    _photoVC.status = data;
    _photoVC.currentIndex = currentIndex;
    
    [_photoVC show];
}








@end
