//
//  CalloutMapAnnotation.m
//  10.3-5
//
//  Created by 田子瑶 on 16/6/30.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation

@synthesize latitude;
@synthesize longitude;
@synthesize locationInfo;

-(id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon{

    if (self = [super init]) {
        self.latitude = lat;
        self.longitude = lon;
    }
    
    return self;
}

-(CLLocationCoordinate2D)coordinate{

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    
    return coordinate;
}


@end
