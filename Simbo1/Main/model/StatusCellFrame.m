//
//  StatusCellFrame.m
//  Simbo1
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "StatusCellFrame.h"
#import "User.h"
#import "Status.h"
#import "HeadImage.h"
#import "ImageListView.h"

@implementation StatusCellFrame


- (void)setStatus:(Status *)status
{
    _status = status;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    //NSLog(@"cellWidth-------%f",cellWidth);
    
    //1.头像
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    CGSize iconSize = [HeadImage iconSizeWithType:kIconTypeSmall];
    _iconFrame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    
    //2.昵称
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth;
    CGFloat screenNameY = iconY;
    CGSize screenNameSize = [StatusCellFrame sizeWithText:status.user.screenName font:kScreenNameFont contentSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _screenNameFrame = CGRectMake(screenNameX, screenNameY, screenNameSize.width, screenNameSize.height);
    
    // 会员图标
    if (status.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconH) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconW, kMBIconH);
    }
    
    //3.时间
    CGFloat timeX = screenNameX;
    CGFloat timeY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
    CGSize timeSize = [StatusCellFrame sizeWithText:status.createdAt font:kTimeFont contentSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _timeFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    //4.来源
    CGFloat sourceX = CGRectGetMaxX(_timeFrame) + kCellBorderWidth;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [StatusCellFrame sizeWithText:status.source font:kSourceFont contentSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _sourceFrame = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    
    //5.内容
    CGFloat textX = kCellBorderWidth;
    CGFloat textY = CGRectGetMaxY(_iconFrame) + kCellBorderWidth;
    CGSize textSize = [StatusCellFrame sizeWithText:status.text font:kTextFont contentSize:CGSizeMake(cellWidth - 2 *kCellBorderWidth, MAXFLOAT)];
    _textFrame = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    //6.配图
    if (status.picUrls.count) {
        CGFloat imageX = kCellBorderWidth;
        CGFloat imageY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
        CGSize imageSize = [ImageListView imageListSizeWithCount:(int)status.picUrls.count];
         _imageFrame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
        
    }else if (status.retweetedStatus){
        //7.转发的整体
        CGFloat retweetX = textX;
        CGFloat retweetY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
        CGFloat retweetWidth = cellWidth - 2 * kCellBorderWidth;
        CGFloat retweetHeight = kCellBorderWidth;
        
        
        //7.1.转发者昵称
        CGFloat retnameX = kCellBorderWidth;
        CGFloat retnameY = kCellBorderWidth;
        NSString *name = [NSString stringWithFormat:@"@%@",status.retweetedStatus.user.screenName];
        CGSize retnameSize = [StatusCellFrame sizeWithText:name font:kRetweetedScreenNameFont contentSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _retweetedScreenNameFrame = CGRectMake(retnameX, retnameY, retnameSize.width, retnameSize.height);
        
        //7.2。转发内容
        CGFloat retweetedTextX = kCellBorderWidth;
        CGFloat retweetedTextY = CGRectGetMaxY(_retweetedScreenNameFrame) + kCellBorderWidth;
        CGSize retweetedTextSize = [StatusCellFrame sizeWithText:status.retweetedStatus.text font:kRetweetedTextFont contentSize:CGSizeMake(cellWidth - 4 * kCellBorderWidth, MAXFLOAT)];
        _retweetedTextFrame = CGRectMake(retweetedTextX, retweetedTextY, retweetedTextSize.width, retweetedTextSize.height + retnameSize.height);
        
       
        // 10.被转发微博的配图
        if (status.retweetedStatus.picUrls.count) {
            //7.3.转发的配图
            CGFloat retweetedImageX = retweetedTextX;
            CGFloat retweetedImageY = CGRectGetMaxY(_retweetedTextFrame) + kCellBorderWidth;
            CGSize retweetedImageSize = [ImageListView imageListSizeWithCount:(int)status.retweetedStatus.picUrls.count];
            _retweetedImageFrame = (CGRect){retweetedImageX, retweetedImageY, retweetedImageSize};
            
            retweetHeight += CGRectGetMaxY(_retweetedImageFrame);
        }else {
            retweetHeight += CGRectGetMaxY(_retweetedTextFrame);
        }
        _retweetedFrame = CGRectMake(retweetX, retweetY, retweetWidth, retweetHeight);
        
    }

    //cell的高度
    _cellHeight = kCellBorderWidth + kCellMargin;
    if (status.picUrls.count) {
        _cellHeight += CGRectGetMaxY(_imageFrame);
    } else if (status.retweetedStatus) {
        _cellHeight += CGRectGetMaxY(_retweetedFrame);
    } else {
        _cellHeight += CGRectGetMaxY(_textFrame);
    }
    
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
