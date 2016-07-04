//
//  SliderControl.h
//  Uber滑动选择
//
//  Created by 田子瑶 on 16/7/1.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderControl : UIControl

@property(nonatomic,strong) UIButton *handler;
@property(nonatomic,strong) UIColor *progressColor;
@property(nonatomic,strong) UIColor *topTitlesColor;

@property(nonatomic,readonly) int selectedIndex;

-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray*)titles;
-(void)setSelectedIndex:(int)selectedIndex;
-(void)setTitlesFont:(NSFont*)font;


@end
