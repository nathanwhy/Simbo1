//
//  MyAnnotation.h
//  Simbo1
//
//  Created by NPHD on 14-6-28.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MapStatus;
@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) MapStatus *status;
//@property (nonatomic, copy) NSString *headImage;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) UIImage *image;
@end
