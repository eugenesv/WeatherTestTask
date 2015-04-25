//
//  MapViewController.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

@interface MapViewController : UIViewController

@property (strong, nonatomic) City *choosenCity;

@end
