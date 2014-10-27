//
//  SendMessageBar.m
//  Simbo1
//
//  Created by nathan on 14-10-27.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "SendMessageBar.h"

@implementation SendMessageBar
{
    UITextView *_textview;
    UIButton *_sendButton;
    UIButton *_emotionButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textview = [[UITextView alloc] init];
        _textview.delegate = self;
        _textview.returnKeyType = UIReturnKeyDone;
        [self addSubview:_textview];
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
        _emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_emotionButton];
    }
    return self;
}

- (void)send
{
    [_textview resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (void)layoutSubviews{
    _emotionButton.frame = CGRectMake(10, 10, 30, 30);
    _textview.frame = CGRectMake(10, 10, self.frame.size.width-50, 30);
    _sendButton.frame = CGRectMake(self.frame.size.width-50, 10, 30, 30);
    
}

@end
