//
//  ViewController.m
//  7-4-1
//
//  Created by 田子瑶 on 16/6/10.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (nonatomic, assign) int clickCount;//点击次数
@property (nonatomic, copy) NSTimer *splashTimer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _clickCount++;
    
    if (_splashTimer==nil) {
        _splashTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(animationStart)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    
    
}


-(void)animationStart{
    
    NSArray*arr = @[@"fade",@"moveIn",@"push",@"reveal",@"pageCurl",
                    @"pageUnCurl",@"rippleEffect",@"suckEffect",@"cube",@"oglFlip"];
    
    //如果点击次数是奇数
    if (_clickCount%2!=0) {
        
            int redIndex = arc4random()%9;
            CATransition*redAnimation = [CATransition animation];
            redAnimation.type = arr[redIndex];
            [self.redView.layer addAnimation:redAnimation forKey:nil];
            
            int greenIndex = arc4random()%9;
            CATransition*greenAnimation = [CATransition animation];
            greenAnimation.type = arr[greenIndex];
            [self.greenView.layer addAnimation:greenAnimation forKey:nil];
            
            int blackIndex = arc4random()%9;
            CATransition*blackAnimation = [CATransition animation];
            blackAnimation.type = arr[blackIndex];
            [self.blackView.layer addAnimation:blackAnimation forKey:nil];
            
            int blueIndex = arc4random()%9;
            CATransition*blueAnimation = [CATransition animation];
            blueAnimation.type = arr[blueIndex];
            [self.blueView.layer addAnimation:blueAnimation forKey:nil];
            
        
    }
}






@end
