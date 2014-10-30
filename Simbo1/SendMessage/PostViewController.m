//
//  PostViewController.m
//  Simbo1
//
//  Created by nathan on 14-10-26.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "PostViewController.h"
#import "SendMessageBar.h"

@interface PostViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextView *_textView;
    SendMessageBar *_sendMessageBar;
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
    [self.view addSubview:_textView];
    
    // 工具栏
    _sendMessageBar = [[SendMessageBar alloc] init];
    _sendMessageBar.frame = CGRectMake(0, 200, kScreenWidth, 50);
    [self.view addSubview:_sendMessageBar];
    
    
    [_textView becomeFirstResponder];
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



#pragma mark - button Click
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMessage{
    MyLog(@"sendmessage");
}



@end
