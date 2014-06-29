//
//  LeftTableViewController.m
//  Simbo1
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "LeftTableViewController.h"
#import "Status.h"
#import "HeadImage.h"
#import "StatusTool.h"
#import "HttpTool.h"
#import "User.h"

@interface LeftTableViewController ()

@end

@implementation LeftTableViewController
{
    User *_user;
    NSArray *_array;
    
    
}
- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 130, 460) style:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadStatuData];
    _array = @[@"特别关注", @"同学", @"朋友", @"家人", @"科技", @"品牌", @"明星", @"新闻评论", @"NBA"];
    

    
    
    [self.tableView reloadData];
}


- (void)loadStatuData
{
    _user = nil;
    _array = [NSMutableArray array];
    //获取登陆用户的uid
    [HttpTool getWithpath:@"2/account/get_uid.json" params:nil success:^(id JSON) {
        //NSLog(@"success%@",JSON);
        
        //用uid获得该用户的资料
        [HttpTool getWithpath:@"2/users/show.json" params:@{@"uid":JSON[@"uid"]} success:^(id JSON) {
            NSLog(@"success%@",JSON);
            
            _user= [[User alloc] initWithDict:JSON];
            
            NSLog(@"statues----%@",_user.profileImageUrl);
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"failed");
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed");
    }];
    
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 120;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc] init];
    [head setBackgroundColor:[UIColor lightGrayColor]];
    
    
    
    HeadImage *icon = [[HeadImage alloc] init];
    [icon setUser:_user type:kIconTypeBig];
    icon.frame = CGRectMake(25, 25, 85, 85);
    
    
    [head addSubview:icon];
    return head;

}
#pragma mark 底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc] init];
    [foot setBackgroundColor:[UIColor lightGrayColor]];
    foot.bounds = CGRectMake(0, 0, self.view.frame.size.width, 60);
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeSystem];
    [setting setTitle:@"设置" forState:UIControlStateNormal];
    setting.frame = CGRectMake(10, 0, 50, 50);
    [setting addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:setting];
    
    UIButton *location = [UIButton buttonWithType:UIButtonTypeSystem];
    [location setTitle:@"地点" forState:UIControlStateNormal];
    location.frame = CGRectMake(70, 0, 50, 50);
    [foot addSubview:location];
    
    UIButton *theme = [UIButton buttonWithType:UIButtonTypeSystem];
    [theme setTitle:@"主题" forState:UIControlStateNormal];
    theme.frame = CGRectMake(130, 0, 50, 50);
    [foot addSubview:theme];
    
    return foot;
}

- (void)clickSetting
{
    NSLog(@"点击设置");
}

#pragma mark -table view 相关方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text = _array[indexPath.row];
    
    return cell;
}



@end
