//
//  PostViewController.m
//  Simbo1
//
//  Created by nathan on 14-10-26.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "PostViewController.h"
#import "SendMessageBar.h"
#import "EmoteSelectorView.h"

@interface PostViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,EmoteSelectorViewDelegate,UITextViewDelegate>
{
    UITextView *_textView;
    SendMessageBar *_sendMessageBar;
    EmoteSelectorView *_emoteView;
}
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发送新消息";
    self.view.backgroundColor = kColor(240, 240, 240);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
   
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
    _textView.frame = (CGRect){0, kNavigator_H, kScreenWidth, 150};
    _textView.backgroundColor = kColor(230, 230, 230);
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    // test
//    _sendMessageBar = [[SendMessageBar alloc] init];
//    _sendMessageBar.frame = CGRectMake(0, 200, kScreenWidth, 50);
//    [self.view addSubview:_sendMessageBar];
    
    CGFloat itemW = self.view.frame.size.width/3;
    CGFloat itemH = 40;
    CGFloat itemY = CGRectGetMaxY(_textView.frame);
    NSArray *btnTitle = @[@"表情",@"照片",@"相机"];
    
    for (int i = 0; i<3; i++) {
        UIButton *emojiBtn = [[UIButton alloc] init];
        emojiBtn.tag = 1024+i;
        [emojiBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        [emojiBtn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [emojiBtn setTitle:@"选择" forState:UIControlStateSelected];
        [emojiBtn setFrame:CGRectMake(itemW*i, itemY, itemW, itemH)];
        [emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:emojiBtn];
    }
    
    
    // 实例化表情选择视图
    _emoteView = [[EmoteSelectorView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    // 设置代理
    _emoteView.delegate = self;
    
    
    
    [_textView becomeFirstResponder];
}

- (void)emojiClick:(UIButton *)sendar{
    
    sendar.selected = !sendar.selected;
    
    [_textView becomeFirstResponder];
    if (sendar.selected) {
        [_textView setInputView:_emoteView];
    }else {
        [_textView setInputView:nil];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_textView reloadInputViews];
    }];
    
}

#pragma mark - 表情选择视图代理方法
// 拼接表情字符串
- (void)emoteSelectorViewSelectEmoteString:(NSString *)emote
{
    NSMutableString *strM = [NSMutableString stringWithString:_textView.text];
    [strM appendString:emote];
    _textView.text = strM;
}

// 删除字符串
- (void)emoteSelectorViewRemoveChar
{
    NSString *str = _textView.text;// 删除最末尾的字符，并设置文本
    _textView.text =  [str substringToIndex:(str.length - 1)];
}


#pragma mark keyboard delegate
- (void)keyboardChangeFrame:(NSNotification *)notification
{
    
    NSDictionary *info = notification.userInfo;
    CGRect rect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        // 关闭键盘
//        _noInputTextConstraint.constant = 0.0;
    } else {
        // 打开键盘
//        _noInputTextConstraint.constant = rect.size.height;
    }
    
    
    [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
//        [self scrollToTableBottom];
    }];
}

#pragma mark add photo
- (IBAction)clickAddPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        NSLog(@"摄像头不可用");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    // 1. 获取选择的图像
//    UIImage *image = info[UIImagePickerControllerEditedImage];
//
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];

}

#pragma mark - textView
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textview = %@",textView.text);
}


#pragma mark - button Click
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMessage{
    MyLog(@"sendmessage");
}



@end
