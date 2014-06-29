//
//  StatusCellFrame.h
//  Simbo1
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//  微博frame

#import <Foundation/Foundation.h>


@class Status;
@interface StatusCellFrame : NSObject
@property (nonatomic, strong) Status *status;

@property (nonatomic, readonly) CGFloat cellHeight; // Cell的高度

@property (nonatomic, readonly) CGRect iconFrame; // 头像的frame

@property (nonatomic, readonly) CGRect screenNameFrame; // 昵称
@property (nonatomic, readonly) CGRect mbIconFrame; // 会员头像
@property (nonatomic, readonly) CGRect timeFrame; // 时间
@property (nonatomic, readonly) CGRect sourceFrame; // 来源
@property (nonatomic, readonly) CGRect textFrame; // 内容
@property (nonatomic, readonly) CGRect imageFrame; // 配图

@property (nonatomic, readonly) CGRect retweetedFrame; // 被转发微博的父控件
@property (nonatomic, readonly) CGRect retweetedScreenNameFrame; // 被转发微博作者的昵称
@property (nonatomic, readonly) CGRect retweetedTextFrame; // 被转发微博的内容
@property (nonatomic, readonly) CGRect retweetedImageFrame; // 被转发微博的配图

- (void)setStatus:(Status *)status;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font contentSize:(CGSize)contentSize;
@end
