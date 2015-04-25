//
//  SEGetWeatherRequest.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "SENetworkRequest.h"

@class City, Weather;

@interface SEGetWeatherRequest : SENetworkRequest

@property (strong, nonatomic) City *currentCity;
@property (strong, nonatomic) Weather *currentWeather;

- (instancetype)initWithCity:(City *)currentCity;

@end
