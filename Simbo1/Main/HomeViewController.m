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

@interface HomeViewController ()<ImageListViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftView;
@end

@implementation HomeViewController
{
    NSMutableArray *_photoData;
    NSMutableArray *_statusFrames;
    UIRefreshControl *_refresh;
    
    PhotoBowserViewController *_photoVC;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self buildUI];//创建UI
    [self loadStatusData];//加载数据
    
    //创建下拉刷新控件
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉加载"];
    [rc addTarget:self action:@selector(refreshNewData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPhoto:) name:@"openPhotoNotification" object:nil];
//    [self refreshNewData:self.refreshControl];
}

#pragma mark  nav按钮响应事件
- (void) sendStatus
{
    NSLog(@"发微博");
}
- (void)popMenu
{
    MapViewController *map = [[MapViewController alloc] init];
    [self presentViewController:map animated:YES completion:nil];
    
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
    long long first = [[_statusFrames[0] status] ID];
    [StatusTool statusesWithSinceID:first maxId:0 Success:^(NSArray *statues) {
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

- (void) loadStatusData
{
    _statusFrames = [NSMutableArray array];
    _photoData = [NSMutableArray array];
    
    // 获取微博数据
    [StatusTool statusesWithSinceID:0 maxId:0 Success:^(NSArray *statues) {
        // 1.在拿到最新微博数据的同时计算它的frame
        _photoData = [NSMutableArray arrayWithArray:statues];//图片数据
        for (Status *s in statues) {
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [_statusFrames addObject:f];
            
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"失败-%@",error);
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
    cell.listView.listViewDelegate = self;

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [_statusFrames[indexPath.row] cellHeight];
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
    //取出字典
    NSDictionary *dic = [notification object];
    UITapGestureRecognizer *tap = dic[@"recognizer"];
    
    UITableView *tableView = (UITableView *)self.view;
    
    //获得配图所在的indexPath
    CGPoint point = [tap locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:point];
    
    
    if (_photoVC == nil) {
        _photoVC = [[PhotoBowserViewController alloc] init];
    }
    
    Status *data =(Status *) _photoData[indexPath.row];
    _photoVC.status = data;
    
    [_photoVC show];
}



@end
