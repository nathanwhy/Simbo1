//
//  PhotoBowserViewController.h
//  Simbo1
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//
//  照片浏览器视图控制器
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface PhotoBowserViewController : UIViewController

// 照片模型数组
@property (strong, nonatomic) NSArray *photoList;
// 当前显示照片的索引
@property (assign, nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) Status *status;
#pragma mark - 显示照片浏览器视图
- (void)show;

@end
