//
//  PhotoView.h
//  Simbo1
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//
//  照片浏览器照片视图
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@class PhotoView;

@protocol PhotoViewDelegate <NSObject>

@optional
- (void)photoViewSingleTap:(PhotoView *)photoView;
- (void)photoViewZoomOut:(PhotoView *)photoView;

@end

@interface PhotoView : UIScrollView

@property (weak, nonatomic) id<PhotoViewDelegate> photoDelegate;

// 照片模型
@property (strong, nonatomic) PhotoModel *photo;

@end
