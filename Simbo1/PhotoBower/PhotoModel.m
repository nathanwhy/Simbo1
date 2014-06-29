//
//  PhotoModel.m
//  Simbo1
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

+ (id)photoWithURL:(NSURL *)url index:(NSInteger)index srcFrame:(CGRect)srcFrame
{
    PhotoModel *p = [[PhotoModel alloc]init];
    
    p.imageUrl = url;
    p.index = index;
    p.srcFrame = srcFrame;
    
    p.firstShow = YES;
    
    return p;
}

// 别忘了写description

@end
