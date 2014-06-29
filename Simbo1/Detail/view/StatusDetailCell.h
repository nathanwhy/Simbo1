//
//  StatusDetailCell.h
//  Simbo1
//
//  Created by NPHD on 14-5-24.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//  微博详情

#import "StatusCell.h"
@class StatusDetailCell;
@class DetailCellFrame;

@protocol StatuesDetailCellDelegate <NSObject>

@required
- (void)statuesDetailCellPushToRetweet:(StatusDetailCell *)DetailCell;

@end


@interface StatusDetailCell : StatusCell
@property (nonatomic, strong) DetailCellFrame *detailCellFrame;

@property (nonatomic, weak) id<StatuesDetailCellDelegate> delegate;
@end
