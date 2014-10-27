//
//  PostViewController.m
//  Simbo1
//
//  Created by nathan on 14-10-26.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()
{
    UITextView *_textView;
}
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发送新消息";
    self.view.backgroundColor = kColor(240, 240, 240);
   
    [self initView];
}

- (void)initView{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigator_H)];
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    naviItem.leftBarButtonItem = leftButton;
    naviItem.rightBarButtonItem = rightButton;
    [bar pushNavigationItem:naviItem animated:YES];
    [self.view addSubview:bar];
    
    _textView = [[UITextView alloc] init];
    _textView.frame = (CGRect){0, kNavigator_H, kScreenWidth, 200};
    _textView.backgroundColor = kColor(230, 230, 230);
    [self.view addSubview:_textView];
    //工具栏
    [_textView becomeFirstResponder];
}

#pragma mark - button Click
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMessage{
    MyLog(@"sendmessage");
}



@end
