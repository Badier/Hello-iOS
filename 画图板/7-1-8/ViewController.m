//
//  ViewController.m
//  7-1-8
//
//  Created by 田子瑶 on 16/6/13.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "ViewController.h"
#import "DoodleView.h"

#define width ([UIScreen mainScreen].bounds.size.width)
#define height ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DoodleView*doodleView = [[DoodleView alloc]initWithFrame:CGRectMake(0, 0, width, height-50)];
    doodleView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:doodleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clean:(id)sender {
    

    
}
- (IBAction)save:(id)sender {
}
- (IBAction)changeWI:(id)sender {
}




@end
