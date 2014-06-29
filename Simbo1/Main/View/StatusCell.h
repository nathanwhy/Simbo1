//
//  StatusCell.h
//  Simbo1
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusCellFrame,ImageListView;


@interface StatusCell : UITableViewCell
{
    UIImageView *_retweeted; // 被转发微博的父控件
    
    
}
@property (nonatomic, strong) StatusCellFrame *statusCellFrame;
@property (nonatomic, strong) ImageListView *listView;
@end
