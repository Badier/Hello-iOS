//
//  DoodleView.m
//  7-1-8
//
//  Created by 田子瑶 on 16/6/13.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "DoodleView.h"

#define width ([UIScreen mainScreen].bounds.size.width)
#define height ([UIScreen mainScreen].bounds.size.height)

@implementation DoodleView{
UISlider *slider;
}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.lineArr = [NSMutableArray array];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{

    self.lineWidth = 5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    for (NSInteger i=0; i<_lineArr.count; i++) {
        NSMutableArray*line = [_lineArr objectAtIndex:i];
        if (line.count<1) {
            continue;
        }
        for (NSInteger k=0; k<line.count-1; k++) {
            NSString*p = [line objectAtIndex:k];
            NSString*p1 = [line objectAtIndex:k+1];
            CGPoint point1 = CGPointFromString(p);
            CGPoint point2 = CGPointFromString(p1);
            CGContextMoveToPoint(context, point1.x, point1.y);
            CGContextAddLineToPoint(context, point2.x, point2.y);
            CGContextStrokePath(context);
        }
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSMutableArray*line = [NSMutableArray array];
    [self.lineArr addObject:line];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch*touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    NSString*point = NSStringFromCGPoint(p);
    
    NSMutableArray*line = [self.lineArr lastObject];
    [line addObject:point];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if ([self.lineArr lastObject] == nil) {
        [self.lineArr removeLastObject];
    }

}

-(void)changeStrokeWidthSlider{
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 50, width, 20)];
    slider.maximumValue = 20;
    slider.minimumValue = 1;
    [self addSubview:slider];

    self.lineWidth = slider.value;
    [self setNeedsDisplay];

}


@end
