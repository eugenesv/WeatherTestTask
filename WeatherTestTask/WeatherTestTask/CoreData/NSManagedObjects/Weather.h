//
//  Weather.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 26.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, CustomImage;

@interface Weather : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * groundLevel;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSDecimalNumber * pressure;
@property (nonatomic, retain) NSDecimalNumber * seaLevel;
@property (nonatomic, retain) NSNumber * sunrise;
@property (nonatomic, retain) NSNumber * sunset;
@property (nonatomic, retain) NSDecimalNumber * temperature;
@property (nonatomic, retain) NSDecimalNumber * temperatureMax;
@property (nonatomic, retain) NSDecimalNumber * temperatureMin;
@property (nonatomic, retain) NSNumber * weatherDate;
@property (nonatomic, retain) NSDecimalNumber * windDegree;
@property (nonatomic, retain) NSDecimalNumber * windSpeed;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) CustomImage *icon;

@end
