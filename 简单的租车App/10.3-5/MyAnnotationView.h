//
//  MyAnnotationView.h
//  10.3-5
//
//  Created by 田子瑶 on 16/6/28.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BusPointCell.h"

@interface MyAnnotationView : MKAnnotationView

@property(nonatomic,retain) UIView *contentView; //添加一个UIView

@property(nonatomic,retain) BusPointCell *busInfoView;
//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView


@end
