//
//  ImageListView.h
//  Simbo1
//
//  Created by NPHD on 14-5-20.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageListView,ImageItemView;
@protocol ImageListViewDelegate <NSObject>

@optional
- (void)ImageListViewShow:(ImageListView *)imageListView imageItem:(ImageItemView *)imageItem recognizer:(UITapGestureRecognizer *)recognizer;

@end

@interface ImageListView : UIView
// 所有图片的url
@property (nonatomic, strong) NSArray *imageUrls;

+ (CGSize)imageListSizeWithCount:(int)count;

@property (nonatomic, weak) id<ImageListViewDelegate> listViewDelegate;

@property (nonatomic,assign) SEL method;
@end
