//
//  ViewController.m
//  Uber滑动选择
//
//  Created by 田子瑶 on 16/7/1.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "ViewController.h"
#import "SliderControl.h"

@interface ViewController (){

    UIView *myView;
    UILabel *myLabel;
    
    SliderControl *slider;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = @[@"日租",@"长租",@"试驾",@"试驾"];
    CGRect rect = CGRectMake(25, 5, self.view.frame.size.width-50, 15);
    slider = [[SliderControl alloc] initWithFrame:rect Titles:arr];

    myView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 100)];
    [self.view addSubview:myView];
    
    [slider setProgressColor:[UIColor groupTableViewBackgroundColor]];//设置滑杆的颜色
    [slider setTopTitlesColor:[UIColor orangeColor]];//设置滑块上方字体颜色
    [slider setSelectedIndex:0];//设置当前选中
    [slider addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventTouchUpInside];

    [myView addSubview:slider];
    
}

-(void)filterValueChanged:(SliderControl*)sender
{
    NSLog(@"当前滑块位置%d",sender.selectedIndex);
    switch (sender.selectedIndex) {
        case 0:
            
            NSLog(@"0");
            
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
        case 3:
            NSLog(@"3");
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
