//
//  BaseTextCellFrame.h
//  Simbo1
//
//  Created by NPHD on 14-5-25.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseText,Status;
@interface BaseTextCellFrame : NSObject

@property (nonatomic, strong) Status *status;
@property (nonatomic, strong) BaseText *baseText;

@property (nonatomic, readonly) CGFloat cellHeight; // Cell的高度

@property (nonatomic, readonly) CGRect iconFrame; // 头像的frame

@property (nonatomic, readonly) CGRect screenNameFrame; // 昵称
@property (nonatomic, readonly) CGRect mbIconFrame; // 会员头像
@property (nonatomic, readonly) CGRect timeFrame; // 时间
@property (nonatomic, readonly) CGRect textFrame; // 内容

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font contentSize:(CGSize)contentSize;
@end
