//
//  DetailViewController.h
//  Simbo1
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//  微博详情控制器

#import <UIKit/UIKit.h>
@class Status;
@interface DetailViewController : UITableViewController
@property (nonatomic, strong) Status *status;
@end
