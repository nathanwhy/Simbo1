//
//  MyAnnotation.m
//  Simbo1
//
//  Created by NPHD on 14-6-28.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "MyAnnotation.h"
#import "MapStatus.h"

@implementation MyAnnotation


- (void)setStatus:(MapStatus *)status
{
    _status = status;
    
    self.title = status.screenName;
    self.subtitle = status.text;
    
}
@end
