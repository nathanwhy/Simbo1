//
//  EmoteSelectorView.m
//  企信通
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "EmoteSelectorView.h"

static unichar emotechars[28] =
{
    0xe415, 0xe056, 0xe057, 0xe414, 0xe405, 0xe106, 0xe418,
    0xe417, 0xe40d, 0xe40a, 0xe404, 0xe105, 0xe409, 0xe40e,
    0xe402, 0xe108, 0xe403, 0xe058, 0xe407, 0xe401, 0xe416,
    0xe40c, 0xe406, 0xe413, 0xe411, 0xe412, 0xe410, 0xe059,
};

#define kRowCount   4
#define kColCount   7
#define kStartPoint CGPointMake(6, 20)
#define kButtonSize CGSizeMake(44, 44)

@implementation EmoteSelectorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor lightGrayColor]];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:28];
        for (NSInteger row = 0; row < kRowCount; row++) {
            for (NSInteger col = 0; col < kColCount; col++) {
                // 计算出按钮索引（第几个按钮）
                NSInteger index = row * kColCount + col;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                NSInteger x = kStartPoint.x + col * kButtonSize.width;
                NSInteger y = kStartPoint.y + row * kButtonSize.height;
                
                [button setFrame:CGRectMake(x, y, kButtonSize.width, kButtonSize.height)];

//                NSString *string = [self emoteStringWithIndex:index];
//                [button setTitle:string forState:UIControlStateNormal];
                
                button.tag = index;
                [button addTarget:self action:@selector(clickEmote:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:button];
                
                [array addObject:button];
            }
        }
        
        // 遍历临时数组，设置按钮内容
        for (UIButton *button in array) {
            if (button.tag == 27) {
                // 最末尾的删除按钮，设置按钮图像
                UIImage *img = [UIImage imageNamed:@"DeleteEmoticonBtn"];
                UIImage *imgHL = [UIImage imageNamed:@"DeleteEmoticonBtnHL"];
                
                [button setImage:img forState:UIControlStateNormal];
                [button setImage:imgHL forState:UIControlStateHighlighted];
            } else {
                
                NSString *string = [self emoteStringWithIndex:button.tag];
                [button setTitle:string forState:UIControlStateNormal];
            }
        }
    }
    
    return self;
}

- (NSString *)emoteStringWithIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%C", emotechars[index]];
}

#pragma mark - 表情按钮点击事件
- (void)clickEmote:(UIButton *)button
{
    NSString *string = [self emoteStringWithIndex:button.tag];
    
    if (button.tag != 27) {
        [_delegate emoteSelectorViewSelectEmoteString:string];
    } else {
        [_delegate emoteSelectorViewRemoveChar];
    }
}

@end
