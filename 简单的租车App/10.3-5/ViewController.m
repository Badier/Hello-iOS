//
//  ViewController.m
//  10.3-5
//
//  Created by 田子瑶 on 16/6/28.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

#import "MyAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "MyAnnotationView.h"

#import "SliderControl.h"


#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width


@interface ViewController ()<MKMapViewDelegate>{
    
    float latitude;
    float longitude;
    CLLocationCoordinate2D coords;
    CalloutMapAnnotation *_calloutMapAnnotation;
    NSMutableArray *carList;
    NSMutableArray *carList2;
    UIView *sliderButtomView;
    SliderControl *slider;
}

@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) UIButton *currentLocationBtn;
@property (nonatomic,retain) UIStepper *mapStepper;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locationManagerLoad];
    [self mapViewLoad];
    [self currentLocationBtnLoad];
    [self mapStepperLoad];
    [self carListLoad];
    [self carList2Load];
    [self addShortCar];
    
    [self sliderLoad];
    
}

-(void)sliderLoad{

    self.view.backgroundColor = [UIColor lightGrayColor];
    sliderButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 80)];
    sliderButtomView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    [self.view addSubview:sliderButtomView];
    
    slider = [[SliderControl alloc]initWithFrame:CGRectMake(25, 5, self.view.frame.size.width-50, 15) Titles:[NSArray arrayWithObjects:@"短租", @"长租", @"试驾", @"试驾", nil]];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [slider setProgressColor:[UIColor groupTableViewBackgroundColor]];//设置滑杆的颜色
    [slider setTopTitlesColor:[UIColor orangeColor]];//设置滑块上方字体颜色
    [slider setSelectedIndex:0];//设置当前选中
    [sliderButtomView addSubview:slider];
    
}

-(NSArray*)carListLoad{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarList" ofType:@"plist"];
    carList = [[NSMutableArray alloc]initWithContentsOfFile:path];
    return carList;
}

-(NSArray*)carList2Load{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarList2" ofType:@"plist"];
    carList2 = [[NSMutableArray alloc]initWithContentsOfFile:path];
    return carList2;
}

-(CLLocationManager*)locationManagerLoad{
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
        _locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    return _locationManager;
}

-(MKMapView*)mapViewLoad{
    
    if (!_mapView) {
        
        CGRect rect = self.view.frame;
        _mapView = [[MKMapView alloc]initWithFrame:rect];
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        
        _mapView.showsUserLocation = YES;
        
        if (_mapView.userLocationVisible) {
            coords = _mapView.userLocation.location.coordinate;
        }
        
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
        
    }
    return _mapView;
}

-(UIButton*)currentLocationBtnLoad{
    
    if (!_currentLocationBtn) {
        _currentLocationBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-130, 40, 40)];
        [_currentLocationBtn setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        [_mapView addSubview:_currentLocationBtn];
        [_currentLocationBtn addTarget:self action:@selector(currentLocationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _currentLocationBtn;
}

-(UIStepper*)mapStepperLoad{
    
    if (!_mapStepper) {
        
        _mapStepper = [[UIStepper alloc]initWithFrame:CGRectMake(SCREENWIDTH-105, SCREENHEIGHT-115, 40, 80)];
        _mapStepper.minimumValue = 500;
        _mapStepper.maximumValue = 10000;
        _mapStepper.value = 3000;
        _mapStepper.stepValue = 500;
        _mapStepper.backgroundColor = [UIColor whiteColor];
        
        //这里图片有问题 传入的图片成纯蓝色的
        [_mapStepper setIncrementImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        [_mapStepper setDecrementImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
        [_mapStepper addTarget:self action:@selector(mapStepperClicked) forControlEvents:UIControlEventTouchUpInside];
        [_mapView addSubview:_mapStepper];
        
    }
    
    return _mapStepper;
}


-(void)sliderValueChanged:(SliderControl *)sender
{
    switch (sender.SelectedIndex) {
        case 0:
            NSLog(@"0");
            [self addShortCar];
            break;
        case 1:
            NSLog(@"1");
            [self addLongCar];
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

-(void)addShortCar{

    [_mapView removeAnnotations: _mapView.annotations];
    
    for (int i=0; i<carList.count; i++) {
        
        NSDictionary *dict = carList[i];
        
        CLLocationDegrees lat = [[dict objectForKey:@"lat"] doubleValue];
        CLLocationDegrees lon = [[dict objectForKey:@"lon"] doubleValue];
        CLLocationCoordinate2D center = {lat,lon};
        
        MyAnnotation *myAnnotation = [[MyAnnotation alloc] init];
        myAnnotation.pointCallOutInfo =dict;
        myAnnotation.coordinate = center;
        myAnnotation.icon = @"5.png";
        [_mapView addAnnotation:myAnnotation];
        
    }
}

-(void)addLongCar{
    
    [_mapView removeAnnotations: _mapView.annotations];
    
    for (int i=0; i<carList2.count; i++) {
        
        NSDictionary *dict = carList2[i];
        
        CLLocationDegrees lat = [[dict objectForKey:@"lat"] doubleValue];
        CLLocationDegrees lon = [[dict objectForKey:@"lon"] doubleValue];
        CLLocationCoordinate2D center = {lat,lon};
        
        MyAnnotation *myAnnotation = [[MyAnnotation alloc] init];
        myAnnotation.pointCallOutInfo =dict;
        myAnnotation.coordinate = center;
        myAnnotation.icon = @"2.png";
        [_mapView addAnnotation:myAnnotation];
        
    }
}

-(void)currentLocationBtnClicked{
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    NSLog(@"%f",latitude);
    NSLog(@"%f",longitude);
}

-(void)mapStepperClicked{
    
    CLLocationCoordinate2D currentMapViewCenter = [_mapView convertPoint:_mapView.center toCoordinateFromView:_mapView];
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(currentMapViewCenter, _mapStepper.value, _mapStepper.value)];
    
    NSLog(@"%f",latitude);
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    coords = userLocation.location.coordinate;
    
    if (coords.latitude != 0 || coords.longitude != 0) {
        
        latitude =  coords.latitude;
        longitude = coords.longitude;
        
    }
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    //CustomPointAnnotation 是自定义的marker标注点，通过这个来得到添加marker时设置的pointCalloutInfo属性
    MyAnnotation *annn = (MyAnnotation*)view.annotation;
    
    if ([view.annotation isKindOfClass:[MyAnnotation class]]) {
        
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation=nil;
            
        }
        //创建搭载自定义calloutview的annotation
        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
        
        //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
        _calloutMapAnnotation.locationInfo = annn.pointCallOutInfo;
        
        [mapView addAnnotation:_calloutMapAnnotation];
        
        [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    if (_calloutMapAnnotation&&![view isKindOfClass:[CalloutMapAnnotation class]]) {
        
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
        
        
    }
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *annotationIdentifier = @"customAnnotation";
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        
        MyAnnotationView *annotationview = [[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        
        annotationview.image = [UIImage imageNamed:@"5.png"];
        annotationview.canShowCallout = NO;
        
        return annotationview;
        
    }
    
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]]){
        
        //此时annotation就是我们calloutview的annotation
        CalloutMapAnnotation *ann = (CalloutMapAnnotation*)annotation;
        
        //如果可以重用
        MyAnnotationView *calloutannotationview = (MyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        
        //否则创建新的calloutView
        if (!calloutannotationview) {
            calloutannotationview = [[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
            
            BusPointCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BusPointCell" owner:self options:nil] objectAtIndex:0];
            
            cell.frame = CGRectMake(0, 0, SCREENWIDTH-20, 80);
            
            [calloutannotationview.contentView addSubview:cell];
            calloutannotationview.busInfoView = cell;
        }
        
        //开始设置添加marker时的赋值
        calloutannotationview.busInfoView.name.text = [ann.locationInfo objectForKey:@"name"];
        calloutannotationview.busInfoView.distance.text = [ann.locationInfo objectForKey:@"distance"];
        calloutannotationview.busInfoView.position.text =[ann.locationInfo objectForKey:@"position"];
        calloutannotationview.busInfoView.price.text =  [ann.locationInfo objectForKey:@"price"];
        NSString *image = [ann.locationInfo objectForKey:@"pic"];
        calloutannotationview.busInfoView.pic.image = [UIImage imageNamed:image];
        
        return calloutannotationview;
        
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
