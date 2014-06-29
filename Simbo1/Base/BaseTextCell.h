//
//  BaseTextCell.h
//  Simbo1
//
//  Created by NPHD on 14-5-25.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//  适用于评论详情和转发详情

#import <UIKit/UIKit.h>
@class BaseTextCellFrame;
@interface BaseTextCell : UITableViewCell

@property (nonatomic, strong)  BaseTextCellFrame *cellFrame;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) UITableView *myTableView;
@end
