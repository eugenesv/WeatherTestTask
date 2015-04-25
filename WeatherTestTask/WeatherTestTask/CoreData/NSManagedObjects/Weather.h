//
//  Weather.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, CustomImage, Wind;

@interface Weather : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * temperature;
@property (nonatomic, retain) NSDecimalNumber * temperatureMax;
@property (nonatomic, retain) NSDecimalNumber * temperatureMin;
@property (nonatomic, retain) NSDecimalNumber * pressure;
@property (nonatomic, retain) NSDecimalNumber * seaLevel;
@property (nonatomic, retain) NSDecimalNumber * groundLevel;
@property (nonatomic, retain) NSNumber * sunrise;
@property (nonatomic, retain) NSNumber * sunset;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) Wind *wind;
@property (nonatomic, retain) CustomImage *icon;

@end
