//
//  HomeViewController.m
//  Simbo1
//
//  Created by NPHD on 14-5-12.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//   首页

#import "HomeViewController.h"
#import "AccountTool.h"
#import "User.h"
#import "Status.h"
#import "StatusTool.h"
#import "StatusCell.h"
#import "StatusCellFrame.h"
#import "DetailViewController.h"
#import "MapViewController.h"
#import "PhotoBowserViewController.h"
#import "ImageListView.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftView;
@end

@implementation HomeViewController
{
    NSMutableArray *_statusData;
    NSMutableArray *_statusFrames;

    UIActivityIndicatorView *_footActivityView;
    
    PhotoBowserViewController *_photoVC;
}

- (void) viewDidLoad
{
    _statusFrames = [NSMutableArray array];
    _statusData = [NSMutableArray array];
    
    [super viewDidLoad];
    [self buildUI];//创建UI
    
    //创建下拉刷新控件
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉加载"];
    [rc addTarget:self action:@selector(refreshNewData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPhoto:) name:@"openPhotoNotification" object:nil];
    [self refreshNewData:self.refreshControl];
}

#pragma mark  nav按钮响应事件
- (void) sendStatus
{
    NSLog(@"发微博");
}

#pragma mark 导航栏右侧按钮
- (void)popMenu
{
    MapViewController *map = [[MapViewController alloc] init];
    [self presentViewController:map animated:YES completion:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 创建UI
- (void) buildUI
{
    self.title = @"首页";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(sendStatus)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStyleBordered target:self action:@selector(popMenu)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

#pragma mark 下拉刷新控件，加载新数据

- (void)refreshNewData:(UIRefreshControl *)refreshControl
{
    StatusCellFrame *f = _statusFrames.count?_statusFrames[0]:nil;
    long long first = [f.status ID];
    
    [StatusTool statusesWithSinceID:first maxId:0 Success:^(NSArray *statues) {
        
        if (first) {
            [_statusData insertObjects:statues atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statues.count)]];
        }else{
            _statusData = [NSMutableArray arrayWithArray:statues];
        }
        
        // 1.在拿到最新微博数据的同时计算它的frame
        
        NSMutableArray *newobject = [NSMutableArray array];
        for (Status *s in statues) {
            
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [newobject addObject:f];
        }
        //2.将newobject插入到旧数据的前面
        [_statusFrames insertObjects:newobject atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newobject.count)]];
        
        //3.刷新表格并停止控件更新
        [self.tableView reloadData];
        [refreshControl endRefreshing];

    } failure:^(NSError *error) {
        [refreshControl endRefreshing];
    }];
    
    
}

#pragma mark 读取数据
- (void) loadOldStatus
{
    // 1.最后1条微博的ID
    StatusCellFrame *f = [_statusFrames lastObject];
    long long last = [f.status ID];
    
    // 2.获取微博数据
    [StatusTool statusesWithSinceID:0 maxId:last - 1 Success:^(NSArray *statues) {
        
        [_statusData addObjectsFromArray:statues];
        // 1.在拿到最新微博数据的同时计算它的frame
        NSMutableArray *newFrames = [NSMutableArray array];
        for (Status *s in statues) {
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [newFrames addObject:f];
        }
        
        // 2.将newFrames整体插入到旧数据的后面
        [_statusFrames addObjectsFromArray:newFrames];
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        // 4.让刷新控件停止刷新状态
        [_footActivityView stopAnimating];
    } failure:^(NSError *error) {
        [_footActivityView stopAnimating];
    }];
}


#pragma mark - tableView 的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.StatusCellFrame = _statusFrames[indexPath.row];

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [_statusFrames[indexPath.row] cellHeight];
}

#pragma mark - 上拉刷新
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    _footActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _footActivityView.color = kDarkBule;
    _footActivityView.frame = CGRectMake(10, 0, 300, 40);
    return _footActivityView;
}



#pragma mark 界面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    StatusCellFrame *f = _statusFrames[indexPath.row];
    detail.status = f.status;
    
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - 显示照片浏览器
- (void) openPhoto:(NSNotification *)notification
{
    if (self.navigationController.topViewController != self) return;
    
    //取出字典
    NSDictionary *dic = [notification object];
    UITapGestureRecognizer *tap = dic[@"recognizer"];
    NSInteger currentIndex = [dic[@"currentIndex"] intValue];
    
    
    //获得配图所在的indexPath
    UITableView *tableView = (UITableView *)self.view;
    CGPoint point = [tap locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
    
    
    if (_photoVC == nil) {
        _photoVC = [[PhotoBowserViewController alloc] init];
    }
    
    Status *data =(Status *) _statusData[indexPath.row];
    _photoVC.status = data;
    _photoVC.currentIndex = currentIndex;
    
    [_photoVC show];
}



#pragma mark - 到底部自动刷新
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    BOOL isRefresh = self.tableView.contentOffset.y + self.tableView.frame.size.height > self.tableView.contentSize.height;
    if (isRefresh) {
        [_footActivityView startAnimating];
        [self loadOldStatus];
    }
}


@end
