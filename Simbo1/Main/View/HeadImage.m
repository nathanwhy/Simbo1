//
//  HeadImage.m
//  Simbo1
//
//  Created by NPHD on 14-5-15.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "HeadImage.h"
#import "HttpTool.h"
#import "User.h"

@implementation HeadImage
{
    UIImageView *_icon; // 头像图片
    UIImageView *_vertify; // 认证图标
    
    NSString *_placehoder; // 占位图片
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 用户头像
        UIImageView *icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        _icon = icon;
        
        // 认证图标
        UIImageView *vertify = [[UIImageView alloc] init];
        [self addSubview:vertify];
        _vertify = vertify;
    }
    return self;
}


#pragma mark 同时设置头像的用户和类型
- (void)setUser:(User *)user type:(IconType)type
{
    self.type = type;
    self.user = user;
}

- (void)setUser:(User *)user
{
    _user = user;
    [HttpTool downloadImage:user.profileImageUrl place:[UIImage imageNamed:_placehoder] imageView:_icon];
    
    //  认证图标
    NSString *verifiedIcon = nil;
    
    if (user.verified == NO) {
        _vertify.hidden = YES;
    }else{
        
    switch (user.verifiedType) {
        case kVerifiedTypeNone: // 没有认证认证
            _vertify.hidden = YES;
            break;
        case kVerifiedTypeDaren: // 微博达人
            verifiedIcon = @"avatar_grassroot.png";
            break;
        case kVerifiedTypePersonal: // 个人
            verifiedIcon = @"avatar_vip.png";
            break;
        default: // 企业认证
            verifiedIcon = @"avatar_enterprise_vip.png";
            break;
          }
    }
    if (verifiedIcon) {
        _vertify.hidden = NO;
        _vertify.image = [UIImage imageNamed:verifiedIcon];
    }
}
- (void)setType:(IconType)type
{
    
    _type = type;
    
    // 1.判断类型
    CGSize iconSize;
    switch (type) {
        case kIconTypeSmall: // 小图标
            iconSize = CGSizeMake(kIconSmallW, kIconSmallH);
            _placehoder = @"avatar_default_small.png";
            break;
            
        case kIconTypeDefault: // 中图标
            iconSize = CGSizeMake(kIconDefaultW, kIconDefaultH);
            _placehoder = @"avatar_default.png";
            break;
            
        case kIconTypeBig: // 大图标
            iconSize = CGSizeMake(kIconBigW, kIconBigH);
            _placehoder = @"avatar_default_big.png";
            break;
    }
    
    // 2.设置frame
    _icon.frame = (CGRect){CGPointZero, iconSize};
    _vertify.bounds = CGRectMake(0, 0, kVertifyW, kVertifyH);
    _vertify.center = CGPointMake(iconSize.width, iconSize.height);
    
    // 3.自己的宽高
    CGFloat width = iconSize.width + kVertifyW * 0.5;
    CGFloat height = iconSize.height + kVertifyH * 0.5;
    self.bounds = CGRectMake(0, 0, width, height);
}



+ (CGSize)iconSizeWithType:(IconType)type
{
    CGSize iconsize;
    if (type == kIconTypeSmall){
        iconsize = CGSizeMake(kIconSmallW, kIconSmallH);
    }else if (type == kIconTypeDefault){
        iconsize = CGSizeMake(kIconDefaultW, kIconDefaultH);
    }else {
        iconsize =CGSizeMake(kIconBigW, kIconBigH);
    }
    CGFloat width = iconsize.width + kVertifyW * 0.5;
    CGFloat height = iconsize.height + kVertifyH * 0.5;
    
    return CGSizeMake(width, height);
  
}

@end
