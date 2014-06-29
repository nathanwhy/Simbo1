//
//  HeadButtonDock.m
//  Simbo1
//
//  Created by NPHD on 14-5-24.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "HeadButtonDock.h"
#import "Status.h"




@interface HeadButtonDock()
{
    UIButton *_commentBtn;
    UIButton *_repostBtn;
    UIButton *_attitudeBtn;
    
    UIButton *_selectedBtn;
}
@end

@implementation HeadButtonDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addButton];
        [self buttonClick:_commentBtn];
        
    }
    return self;
}

- (void)addButton
{
    CGFloat buttonWidth = self.frame.size.width / 3;
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(0, 0, buttonWidth, kButtonH);
    _commentBtn.tag = 101;
    [_commentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
        
    _repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _repostBtn.frame = CGRectMake(buttonWidth, 0, buttonWidth, kButtonH);
    _repostBtn.tag = 102;
    [_repostBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_repostBtn];
        
    _attitudeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attitudeBtn.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, kButtonH);
    [self addSubview:_attitudeBtn];
}

- (void)buttonClick:(UIButton *)sender
{
    // 控制状态
    _selectedBtn.enabled = YES;
    sender.enabled = NO;
    
    _selectedBtn = sender;
    HeadButtonType type = (sender == _repostBtn)?kHeadButtonTypeRepost:kHeadButtonTypeComment;
    _currentBtnType = type;
    
    if ([_delegate respondsToSelector:@selector(HeadButtonDock:btnClick:)]) {
        
        [_delegate HeadButtonDock:self btnClick:type];
        
        
    }
    
}

- (void)setStatus:(Status *)status
{
    _status = status;
    
    [self setBtn:_commentBtn title:@"评论" count:status.commentsCount];
    [self setBtn:_repostBtn title:@"转发" count:status.repostsCount];
    [self setBtn:_attitudeBtn title:@"赞" count:status.attitudesCount];
}

- (void)setBtn:(UIButton *)btn title:(NSString *)title count:(int)count
{
    if (count >= 10000) { // 上万
        CGFloat final = count / 10000.0;
        title = [NSString stringWithFormat:@"%.1f万 %@", final, title];
        // 替换.0为空串
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [btn setTitle:title forState:UIControlStateNormal];
        
    } else { // 一万以内
        title = [NSString stringWithFormat:@"%d %@", count, title];
        [btn setTitle:title forState:UIControlStateNormal];
        
    }
    
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:kDarkBule forState:UIControlStateDisabled];
    
    
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = kButtonH;
    [super setFrame:frame];
}













@end
