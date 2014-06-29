//
//  HeadImage.h
//  Simbo1
//
//  Created by NPHD on 14-5-15.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kIconTypeSmall,
    kIconTypeDefault,
    kIconTypeBig
} IconType;

@class User;
@interface HeadImage : UIImageView

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) IconType type;

- (void)setUser:(User *)user type:(IconType)type;

+ (CGSize)iconSizeWithType:(IconType)type;
@end
