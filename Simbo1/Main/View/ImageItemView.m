//
//  ImageItemView.m
//  Simbo1
//
//  Created by NPHD on 14-5-20.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "ImageItemView.h"
#import "HttpTool.h"



@implementation ImageItemView
{
    UIImageView *_gifView;
    NSString *_url;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif.png"]];
        
        [self addSubview:gifView];
        _gifView = gifView;
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (NSString *)url
{
    return _url;
}


- (void)setUrl:(NSString *)url
{
    _url = url;
    
    // 1.加载图片
    [HttpTool downloadImage:url place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:self];
    
    // 2.是否为gif
    _gifView.hidden = ![url.lowercaseString hasSuffix:@"gif"];

}



- (void)setFrame:(CGRect)frame
{
    // 1.设置gifView的位置
    CGRect gifFrame = _gifView.frame;
    gifFrame.origin.x = frame.size.width - gifFrame.size.width;
    gifFrame.origin.y =  frame.size.height - gifFrame.size.height;
    _gifView.frame = gifFrame;
    
    [super setFrame:frame];
}








@end
