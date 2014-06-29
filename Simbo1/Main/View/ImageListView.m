//
//  ImageListView.m
//  Simbo1
//
//  Created by NPHD on 14-5-20.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//
#define kCount 9

#define kOneW 120
#define kOneH 120

#define kMultiW 80
#define kMultiH 80
#define kMargin 10

#import "ImageListView.h"
#import "ImageItemView.h"

@implementation ImageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (int i = 0; i < kCount; i++) {
            ImageItemView *image = [[ImageItemView alloc] init];
            image.userInteractionEnabled = YES;
            image.tag = 110 + i;
            [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)]];
            
            [self addSubview:image];
        }
        self.userInteractionEnabled = YES;
        
    }
    return self;
}



- (void)openImage:(UITapGestureRecognizer *)recognizer
{
    
    ImageItemView *itemView = (ImageItemView *)recognizer.view;
    NSInteger index = itemView.tag - 110;
    
//    NSString *currentImageUrl = [itemView url];
//    NSArray *imageUrls = self.imageUrls;

    NSDictionary *dic = @{@"recognizer": recognizer, @"currentIndex": @(index)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPhotoNotification" object:dic];
}


- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    for (int i = 0; i < kCount; i++) {
        
        // 1.取出对应位置的子控件
        ImageItemView *child = self.subviews[i];
        
        // 2.不要显示图片
        if (i >= imageUrls.count) {
            child.hidden = YES;
            continue;
        }
        
        // 需要显示图片
        child.hidden = NO;
        
        // 3.设置图片
        child.url = imageUrls[i][@"thumbnail_pic"];
        
        // 4.设置frame
        if (imageUrls.count == 1) { // 1张
            child.contentMode = UIViewContentModeScaleAspectFit;
            child.frame = CGRectMake(0, 0, kOneW, kOneH);
            continue;
        }
        
        // 超出边界的减掉
        child.clipsToBounds = YES;
        child.contentMode = UIViewContentModeScaleAspectFill;
        
        int temp = (imageUrls.count == 4) ? 2 : 3;
        CGFloat row = i/temp; // 行号
        CGFloat column = i%temp; // 列号
        CGFloat x = (kMultiW + kMargin) * column;
        CGFloat y = (kMultiH + kMargin) * row;
        child.frame = CGRectMake(x, y, kMultiW, kMultiH);
    }
}


+ (CGSize)imageListSizeWithCount:(int)count
{
    //只有一张图片
    if (count == 1) {
        return CGSizeMake(kOneW, kOneH);
    }
    
    // 2.多张图片
    CGFloat countRow = (count == 4) ? 2 : 3;
    // 总行数
    int rows = (count + countRow - 1) / countRow;
    // 总列数
    int columns = (count >= 3) ? 3 : 2;
    
    CGFloat width = columns * kMultiW + (columns - 1) * kMargin;
    CGFloat height = rows * kMultiH + (rows - 1) * kMargin;
    return CGSizeMake(width, height);
}


@end
