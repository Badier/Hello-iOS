//
//  MyAnnotation.h
//  10.3-5
//
//  Created by 田子瑶 on 16/6/28.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSDictionary *pointCallOutInfo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *icon;

@end
