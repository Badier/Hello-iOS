//
//  SliderKonb.m
//  Uber滑动选择
//
//  Created by 田子瑶 on 16/7/1.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "SliderKonb.h"

@implementation SliderKonb

@synthesize handlerColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setHandlerColor:[UIColor colorWithRed:230 green:230 blue:230 alpha:0]];
        
    }
    return self;
}

-(void)setHandlerColor:(UIColor *)hc{
    
    handlerColor = nil;
    
    [self setNeedsDisplay];
    
    UIImage *imgON = [UIImage imageNamed:@"sliderWifiOn.png"];
    UIImage *imgOff = [UIImage imageNamed:@"sliderWifiOff"];
    
    //设置边距
    CGFloat top,bottom,left,right = 0;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, bottom, left, right);
    
    /*typedef NS_ENUM(NSInteger, UIImageResizingMode) {
     UIImageResizingModeTile,//进行区域复制模式拉伸
     UIImageResizingModeStretch,//进行渐变复制模式拉伸};
     
     resizableImageWithCapInsets 基于边距创建一个可伸缩图片（偏移值内的图片内容将不被拉伸或压缩）*/
    
    imgON = [imgON resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    imgOff = [imgOff resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

    [self setBackgroundImage:imgON forState:UIControlStateNormal];
    [self setBackgroundImage:imgOff forState:UIControlStateSelected];
}

@end
