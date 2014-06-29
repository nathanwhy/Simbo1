//
//  BaseTextCell.m
//  Simbo1
//
//  Created by NPHD on 14-5-25.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "BaseTextCell.h"
#import "HeadImage.h"
#import "BaseText.h"
#import "BaseTextCellFrame.h"
#import "User.h"

@implementation BaseTextCell
{
    HeadImage *_icon; // 头像
    UILabel *_screenName; // 昵称
    UIImageView *_mbIcon; // 会员图标
    UILabel *_time; // 时间
    UILabel *_text; // 内容
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllSubview];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    frame.origin.x = kTableBorderWidth;
    frame.origin.y += kTableBorderWidth;
    frame.size.width -= kTableBorderWidth * 2;
    frame.size.height -= kCellMargin;

    [super setFrame:frame];
}


- (void)addAllSubview
{
    //1.头像
    _icon = [[HeadImage alloc] init];
    _icon.type = kIconTypeSmall;
    [self.contentView addSubview:_icon];
    
    //2.昵称
    _screenName = [[UILabel alloc] init];
    _screenName.font = kScreenNameFont;
    _screenName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_screenName];
    
    // 皇冠图标
    _mbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership.png"]];
    [self.contentView addSubview:_mbIcon];
    
    //3.时间
    _time = [[UILabel alloc] init];
    _time.font = kTimeFont;
    _time.textColor = kMBScreenNameColor;
    _time.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_time];
    
    //5.内容
    _text = [[UILabel alloc] init];
    _text.font = kTextFont;
    _text.numberOfLines = 0;
    _text.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_text];
}

- (void)setCellFrame:(BaseTextCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    BaseText *s = cellFrame.baseText;
    
    // 1.头像
    _icon.frame = cellFrame.iconFrame;
    [_icon setUser:s.user type:kIconTypeSmall];
    
    // 2.昵称
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = s.user.screenName;
    // 判断是不是会员
    if (!(s.user.mbtype < 3)) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 3.时间
    _time.text = s.createdAt;
    CGFloat timeY = cellFrame.iconFrame.origin.y;
    CGSize timeSize = [BaseTextCellFrame sizeWithText:s.createdAt font:kTimeFont contentSize:CGSizeMake(MAXFLOAT, kTimeFont.lineHeight)];
    CGFloat timeX = self.frame.size.width - timeSize.width - kCellBorderWidth;
    _time.frame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    // 4.内容
    
    _text.text = s.text;
    _text.frame = cellFrame.textFrame;
}

@end
