//
//  BaseTextCellFrame.m
//  Simbo1
//
//  Created by NPHD on 14-5-25.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "BaseTextCellFrame.h"
#import "User.h"
#import "BaseText.h"
#import "HeadImage.h"

@implementation BaseTextCellFrame
- (void)setBaseText:(BaseText *)baseText
{
    _baseText = baseText;
    
    // 整个cell的宽度
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width -kCellBorderWidth/2;
    
    // 1.头像
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    CGSize iconSize = [HeadImage iconSizeWithType:kIconTypeSmall];
    _iconFrame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    
    // 2.昵称
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) ;
    CGFloat screenNameY = iconY;
    
    CGSize screenNameSize = [BaseTextCellFrame sizeWithText:baseText.user.screenName font:kScreenNameFont contentSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    
    // 会员图标
    if (baseText.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconH) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconW, kMBIconH);
    }
    
    // 3.微博\评论的内容
    CGFloat textX = screenNameX;
    CGFloat textY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
    CGFloat textWidth = cellWidth - kCellBorderWidth - textX;
    CGSize textSize = [BaseTextCellFrame sizeWithText:baseText.text font:kTextFont contentSize:CGSizeMake(cellWidth - screenNameX - kTableBorderWidth * 2, MAXFLOAT)];
    _textFrame = (CGRect){{textX, textY}, textSize};
    
    // 4.时间
    
    CGFloat timeY = iconY;
    CGSize timeSize = CGSizeMake(textWidth, kTimeFont.lineHeight);
    CGFloat timeX = cellWidth - timeSize.width;
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
    
    // 5.cell的高度
    _cellHeight = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
    
    
}
// 根据文本字体返回size
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font contentSize:(CGSize)contentSize
{
    
    NSDictionary *Atrri = @{NSFontAttributeName : font};
    CGRect Rect = [text boundingRectWithSize:contentSize
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                  attributes:Atrri
                                     context:nil];
    
    return Rect.size;
}
@end
