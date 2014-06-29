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
    // 滚动视图
    UIScrollView            *_scroll;
    
    UIProgressView *_progressView;//进度条视图
    UIImageView *_imageView;
    UIScrollView *_scrollItem;
    
    UITapGestureRecognizer *_tap;
    UITapGestureRecognizer *_doubleTap;
}

@end

@implementation PhotoBowserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
    
    //单击返回
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:_tap];
    
    //双击缩放图片
    _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    _doubleTap.numberOfTapsRequired = 2;
    [_tap requireGestureRecognizerToFail:_doubleTap];//双击优先
}

- (void)back
{
    [self.view removeFromSuperview];
    self.view = nil;
    [self removeFromParentViewController];
    
}

#pragma mark - 显示控制器
- (void)show
{
    // 借助UIApplication中的window
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    // 显示照片视图
    [self showPhotos];
}

#pragma mark - 显示照片
- (void) showPhotos
{
    NSString *imageUrl = nil;
    
    //如果没有图片链接，返回
    if (self.status.original_pic) {
        imageUrl = self.status.original_pic;
        
    }else if(self.status.retweetedStatus.original_pic){
        imageUrl = self.status.retweetedStatus.original_pic;
        
    }else return;
    NSInteger index = self.currentIndex;
    MyLog(@"打开了第%li张图片",index);
    MyLog(@"暂时没有多个大图的接口，只能显示第一张");
    
    //进度条
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setCenter:self.view.center];
    [self.view addSubview:_progressView];
    
    //图片下载
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options: SDWebImageDownloaderProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
        
        //显示下载进度
        CGFloat received = receivedSize;
        CGFloat expected = expectedSize;
        CGFloat progress = received / expected;//下载进度的百分比
        
        [_progressView setProgress:progress animated:YES];
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        
        if (image && finished) {//图片下载成功
            
            [_progressView removeFromSuperview];
            _progressView = nil;
            
            _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            _imageView.image = image;
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView.userInteractionEnabled = YES;
            
            _scrollItem = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            _scrollItem.maximumZoomScale = 3;
            _scrollItem.delegate = self;
            
            //添加双击手势
            [_scrollItem addGestureRecognizer:_doubleTap];
            
            [_scrollItem addSubview:_imageView];
            [self.view addSubview:_scrollItem];
            
        }
    }];
}

#pragma mark - 伸缩图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


#pragma mark - 双击手势
- (void)doubleTap:(UITapGestureRecognizer *)recognizer
{
    if (_scrollItem.zoomScale == _scrollItem.maximumZoomScale) {//缩小图片
        [_scrollItem setZoomScale:1 animated:YES];
        
    }else{//放大图片
        CGPoint point = [recognizer locationInView:self.view];
        [_scrollItem zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}


@end