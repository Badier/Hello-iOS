//
//  SliderControl.m
//  Uber滑动选择
//
//  Created by 田子瑶 on 16/7/1.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "SliderControl.h"

#define LEFT_OFFSET 20
#define RIGHT_OFFSET 20
#define TITLE_SELECTED_DISTANCE 9
#define TITLE_FADE_ALPHA 0.5f
//#define TITLE_FONT [UIFont fontWithName:@"Optima" size:10]//源码
#define TITLE_FONT [UIFont systemFontOfSize:10]
#define TITLE_SHADOW_COLOR [UIColor lightGrayColor]
#define TITLE_COLOR [UIColor blackColor]

@interface SliderControl() {
    
    CGPoint diffPoint;
    NSArray *titlesArr;
    float oneSlotSize;
}

@end

@implementation SliderControl

@synthesize progressColor,topTitlesColor,selectedIndex;


-(CGPoint)getCenterForIndex:(int)i{
    
    CGFloat x = i/(float)(titlesArr.count-1) * (self.frame.size.width-RIGHT_OFFSET-LEFT_OFFSET) + LEFT_OFFSET;
    CGFloat y = i==0?self.frame.size.height-55-TITLE_SELECTED_DISTANCE:self.frame.size.height-55;
    
    /* if (i==0) { CGFloat y = self.frame.size.height-55-TITLE_SELECTED_DISTANCE;}
     else { CGFloat y = self.frame.size.height-55; } */
    return CGPointMake(x, y);
}

-(CGPoint)fixFinalPoint:(CGPoint)pnt{
    
    if (pnt.x < LEFT_OFFSET-(_handler.frame.size.width/2.f)) {
        pnt.x = LEFT_OFFSET-(_handler.frame.size.width/2.f);
    }
    
    else if (pnt.x+(_handler.frame.size.width/2.f) > self.frame.size.width-RIGHT_OFFSET){
        pnt.x = self.frame.size.width-RIGHT_OFFSET- (_handler.frame.size.width/2.f);
    }
    
    return pnt;
}

-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles{

    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 70);
    
    if (self = [super initWithFrame:rect]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        titlesArr = [[NSArray array] initWithArray:titles];
        
        [self setProgressColor:[UIColor colorWithRed:103/255.f green:173/255.f blue:202/255.f alpha:1]];
        [self setTopTitlesColor:[UIColor colorWithRed:103/255.f green:173/255.f blue:202/255.f alpha:1]];
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] init];
        [gest addTarget:self action:@selector(ItemSelected:)];
        [self addGestureRecognizer:gest];
        
        /* UIButtonTypeCustom ：是一个背景透明的按钮。  如果想做按钮中图片切换（不同状态），必须使用两张图片进行设置。*/
        _handler = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handler setFrame:CGRectMake(LEFT_OFFSET, 8, 45, 45)];

        /*adjustsImageWhenHighlighted设置为NO, 则在用户按下时自动修改highlighted状态下的按钮图片为50%透明度。*/
        [_handler setAdjustsImageWhenDisabled:NO];
        [_handler setSelected:YES];

        [_handler setCenter:CGPointMake(_handler.center.x-(_handler.frame.size.width/2.f), self.frame.size.height-29.5f)];
        [_handler addTarget:self action:@selector(touchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
        [_handler addTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_handler addTarget:self action:@selector(TouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
        
        UIImage *imgON = [UIImage imageNamed:@"sliderWifiOn.png"];
        UIImage *imgOff = [UIImage imageNamed:@"sliderWifiOff.png"];
        
        //设置边距
        CGFloat top,bottom,left,right = 0;
        UIEdgeInsets insets = UIEdgeInsetsMake(top, bottom, left, right);
        
        imgON = [imgON resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        imgOff = [imgOff resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        [_handler setBackgroundImage:imgON forState:UIControlStateNormal];
        [_handler setBackgroundImage:imgOff forState:UIControlStateSelected];
        
        [self addSubview:_handler];
        
        int i;
        NSString *title;
        UILabel *lbl;
        
        oneSlotSize = 1.f*(self.frame.size.width-LEFT_OFFSET-RIGHT_OFFSET-1)/(titlesArr.count-1);

        for (i=0; i<titlesArr.count; i++) {
            
            title = [titlesArr objectAtIndex:i];
            
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, oneSlotSize, 10)];
            [lbl setText:title];
            [lbl setFont:TITLE_FONT];
            [lbl setTextColor:TITLE_COLOR];
            
            //用于设置文本不能完全显示时 现在是abc...xyz
            [lbl setLineBreakMode:NSLineBreakByTruncatingMiddle];
            //自动调整字体大小以适应lbl的宽度
            [lbl setAdjustsFontSizeToFitWidth:YES];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            //阴影偏移量
            [lbl setShadowOffset:CGSizeMake(0, 1)];
            [lbl setTag:i+50];
            
            if (i) {
                [lbl setAlpha:TITLE_FADE_ALPHA];
            }
            
            [lbl setCenter:[self getCenterForIndex:i]];
            [self addSubview:lbl];
        
        }
        
    }
    return self;
}

//
// - (void)drawRect:(CGRect)rect {
//     CGContextRef context = UIGraphicsGetCurrentContext();
//     
//     CGColorRef shadowColor = [UIColor colorWithRed:0 green:0
//                                               blue:0 alpha:.9f].CGColor;
//     
//     
//     //Fill Main Path
//     
//     //原代码CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
//     //CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//     CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
//     
//     //源码为(context, CGRectMake(LEFT_OFFSET, rect.size.height-35, rect.size.width-RIGHT_OFFSET-LEFT_OFFSET, 10))
//     CGContextFillRect(context, CGRectMake(LEFT_OFFSET, rect.size.height-32.5, rect.size.width-RIGHT_OFFSET-LEFT_OFFSET, 5));
//     
//     CGContextSaveGState(context);
//     
//     //Draw Black Top Shadow
//     
//     CGContextSetShadowWithColor(context, CGSizeMake(0, 1.f), 2.f, shadowColor);
//     
//     CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
//                                                                blue:0 alpha:.2f].CGColor);
//     CGContextSetLineWidth(context, .4f);
//     CGContextBeginPath(context);
//     CGContextMoveToPoint(context, LEFT_OFFSET, rect.size.height-32.5);
//     CGContextAddLineToPoint(context, rect.size.width-RIGHT_OFFSET, rect.size.height-32.5);
//     CGContextStrokePath(context);
//     
//     CGContextRestoreGState(context);
//     
//     CGContextSaveGState(context);
//     
//     //Draw White Bottom Shadow
//     
//     CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
//                                                                blue:0 alpha:.2f].CGColor);
//     CGContextSetLineWidth(context, .4f);
//     CGContextBeginPath(context);
//     CGContextMoveToPoint(context, LEFT_OFFSET, rect.size.height-27.5);
//     CGContextAddLineToPoint(context, rect.size.width-RIGHT_OFFSET, rect.size.height-27.5);
//     CGContextStrokePath(context);
//     
//     CGContextRestoreGState(context);
//     
//     
//     CGPoint centerPoint;
//     int i;
//     for (i = 0; i < titlesArr.count; i++) {
//         centerPoint = [self getCenterForIndex:i];
//         
//         //Draw Selection Circles 小圆圈
//         
//         //源代码CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
//         //CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//         CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
//         
//         CGContextFillEllipseInRect(context, CGRectMake(centerPoint.x-10, rect.size.height-38.0f, 15, 15));
//         
//         //Draw top Gradient
//         
//         //        CGFloat colors[12] =   {0, 0, 0, 1,
//         //                                0, 0, 0, 0,
//         //                                0, 0, 0, 0};
//         //        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
//         //        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 3);
//         //
//         //        CGContextSaveGState(context);
//         //        CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x-15, rect.size.height-42.5f, 25, 25));
//         //        CGContextClip(context);
//         //        CGContextDrawLinearGradient (context, gradient, CGPointMake(0, 0), CGPointMake(0,rect.size.height), 0);
//         //        CGContextRestoreGState(context);
//         
//         //Draw White Bottom Shadow 小圆圈的上半部分圆弧
//         
//         CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
//                                                                    blue:0 alpha:.2f].CGColor);
//         CGContextSetLineWidth(context, .4f);
//         CGContextAddArc(context,centerPoint.x-2.0,rect.size.height-30.5f,7.0f,18*M_PI/180,165*M_PI/180,0);
//         CGContextDrawPath(context,kCGPathStroke);
//         
//         //Draw Black Top Shadow  小圆圈的下半部分圆弧
//         
//         CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
//                                                                    blue:0 alpha:.2f].CGColor);
//         
//         CGContextAddArc(context,centerPoint.x-2.0,rect.size.height-30.5f,7.0f,(i==titlesArr.count-1?18:-14)*M_PI/180,(i==0?-198:-170)*M_PI/180,1);
//         CGContextSetLineWidth(context, .4f);
//         CGContextDrawPath(context,kCGPathStroke);
//     }
// }

-(void)touchDown:(UIButton*)btn withEvent:(UIEvent*) ev{
    
    //声明一个UITouch的指标来存放事件触发时所撷取到的状态
    UITouch *iTouch = [[ev allTouches] anyObject];
    //获取手指触摸在当前视图上的位置
    CGPoint currPoint = [iTouch locationInView:self];
    diffPoint = CGPointMake(currPoint.x - btn.frame.origin.x, currPoint.y - btn.frame.origin.y);
    //触发事件
    [self sendActionsForControlEvents:UIControlEventTouchDown];

}

-(void) setTitlesFont:(UIFont *)font{
    int i;
    UILabel *lbl;
    for (i = 0; i < titlesArr.count; i++) {
        lbl = (UILabel *)[self viewWithTag:i+50];
        [lbl setFont:font];
    }
}

-(void)animateTitlesToIndex:(int)index{

    int i;
    UILabel *lbl;
    
    for (i=0; i<titlesArr.count; i++) {
        lbl = [self viewWithTag:i+50];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        if (i == index) {
            //选中时label颜色
            [lbl setCenter:CGPointMake(lbl.center.x, self.frame.size.height-55-TITLE_SELECTED_DISTANCE)];
            [lbl setTextColor: self.topTitlesColor];
            [lbl setAlpha:1];
        }
        else{
            //未选中时label颜色
            [lbl setCenter:CGPointMake(lbl.center.x, self.frame.size.height-55)];
            [lbl setTextColor:TITLE_COLOR];
            [lbl setAlpha:1];
        }
        
        [UIView commitAnimations];
    }
}

-(void)animateHandlerToIndex:(int)index{

    CGPoint toPoint = [self getCenterForIndex:index];
    toPoint = CGPointMake(toPoint.x-(_handler.frame.size.width/2.f), _handler.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint];

    [UIView beginAnimations:nil context:nil];
    [_handler setFrame:CGRectMake(toPoint.x, toPoint.y, _handler.frame.size.width, _handler.frame.size.height)];
    [UIView commitAnimations];
    
}

-(void) setSelectedIndex:(int)index{
    selectedIndex = index;
    [self animateTitlesToIndex:index];
    [self animateHandlerToIndex:index];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(int)getSelectedTitleInPoint:(CGPoint)pnt{
    return round((pnt.x-LEFT_OFFSET)/oneSlotSize);
}

-(void) ItemSelected: (UITapGestureRecognizer *) tap {
    selectedIndex = [self getSelectedTitleInPoint:[tap locationInView:self]];
    [self setSelectedIndex:selectedIndex];
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void) TouchUp: (UIButton*) btn{
    btn.selected = YES;
    selectedIndex = [self getSelectedTitleInPoint:btn.center];
    [self animateHandlerToIndex:selectedIndex];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) TouchMove: (UIButton *) btn withEvent: (UIEvent *) ev {
    btn.selected = NO;
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    
    CGPoint toPoint = CGPointMake(currPoint.x-diffPoint.x, _handler.frame.origin.y);
    
    toPoint = [self fixFinalPoint:toPoint];
    
    [_handler setFrame:CGRectMake(toPoint.x, toPoint.y, _handler.frame.size.width, _handler.frame.size.height)];
    
    int selected = [self getSelectedTitleInPoint:btn.center];
    
    [self animateTitlesToIndex:selected];
    
    [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}

@end
