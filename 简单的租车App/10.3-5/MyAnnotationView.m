//
//  MyAnnotationView.m
//  10.3-5
//
//  Created by 田子瑶 on 16/6/28.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "MyAnnotationView.h"
#import "MyAnnotation.h"

//#import <QuartzCore/QuartzCore.h>
#define  Arror_height 6

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@implementation MyAnnotationView

@synthesize contentView;
@synthesize busInfoView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}


-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, SCREENWIDTH-20, 100);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT/2-170, SCREENWIDTH, self.frame.size.height-15)];

        [self addSubview:_contentView];
        self.contentView = _contentView;
    }
    return self;
    
}




@end
