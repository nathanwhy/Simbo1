//
//  HeadButtonDock.h
//  Simbo1
//
//  Created by NPHD on 14-5-24.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtonH 30

@class Status, HeadButtonDock;

typedef enum{
    kHeadButtonTypeRepost, // 转发
    kHeadButtonTypeComment // 评论
} HeadButtonType;


@protocol HeadButtonDelegate <NSObject>
@optional
- (void)HeadButtonDock:(HeadButtonDock *)header btnClick:(HeadButtonType )index;

@end

@interface HeadButtonDock : UIView

@property (nonatomic, strong) Status *status;
@property (nonatomic, weak) id<HeadButtonDelegate> delegate;

@property (nonatomic, assign, readonly) HeadButtonType currentBtnType;
@end
