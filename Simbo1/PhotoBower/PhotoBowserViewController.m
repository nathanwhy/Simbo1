//
//  PhotoBowserViewController.m
//  Simbo1
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "PhotoBowserViewController.h"
#import "UIImageView+WebCache.h"
#import "HttpTool.h"
#import "SDWebImageDownloader.h"

@interface PhotoBowserViewController () <UIScrollViewDelegate>
{
    // 上级窗体状态栏隐藏状态
    BOOL                    _parentStatusBarHidden;
    // 滚动视图
    UIScrollView            *_scroll;
    
    // 缓存数据
    // 1) 可重用视图集合
    NSMutableSet            *_reusablePhotoViewSet;
    // 2) 屏幕上可见的视图字典
    NSMutableDictionary     *_visiblePhotoViewDict;
}

@end

@implementation PhotoBowserViewController

//- (void)loadView
//{
//    // 1. 全屏显示
//    _parentStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
//    // 2 隐藏状态栏，实现全屏显示显示
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    
    // 3. 实例化UIScrollView
//    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    
//    [scroll setBackgroundColor:[UIColor blackColor]];
//    // 4. 隐藏滚动条
//    [scroll setShowsHorizontalScrollIndicator:NO];
//    [scroll setShowsVerticalScrollIndicator:NO];
//    [scroll setPagingEnabled:YES];
//    // 5) 设置代理
//    [scroll setDelegate:self];
//    
//    _scroll = scroll;
    
//    // 将滚动视图作为根视图
//    self.view = scroll;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:tap];
}

- (void)back
{
    [self.view removeFromSuperview];
    self.view = nil;
    [self removeFromParentViewController];
    
}

#pragma mark - 成员方法
- (void)show
{
    // 借助UIApplication中的window
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    // 将根视图添加到window中
    [window addSubview:self.view];
    // 记录住视图控制器
    [window.rootViewController addChildViewController:self];
    
    // 显示照片视图
    [self showPhotos];
}

#pragma mark - 显示照片
- (void) showPhotos
{
    NSString *imageUrl = nil;
    
    if (self.status.original_pic) {
        imageUrl = self.status.original_pic;
        
    }else if(self.status.retweetedStatus.original_pic){
        imageUrl = self.status.retweetedStatus.original_pic;
        
    }else return;
    
    //进度条
    
    NSLog(@"%@",imageUrl);
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options: SDWebImageDownloaderProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
        
        //显示下载进度
        CGFloat progress = receivedSize / expectedSize;
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.center = self.view.center;
        [progressView setProgress:progress animated:YES];
        NSLog(@"%lu,%lld",(unsigned long)receivedSize, expectedSize);
        NSLog(@"%0.2f",progress);
        [self.view addSubview:progressView];
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        
        if (image && finished) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            imageView.image = image;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            
            UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            scroll.contentSize = CGSizeMake(600, 600);
            scroll.minimumZoomScale = 0.5;
            scroll.minimumZoomScale = 2;
            scroll.delegate = self;
            [scroll addSubview:imageView];
            
            [self.view addSubview:scroll];
            
        }
        
    }];
    
    
    
    
    
}


@end