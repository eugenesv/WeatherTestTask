//
//  City.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weather;

@interface City : NSManagedObject

@property (nonatomic, retain) NSNumber * cityId;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSDecimalNumber * cityLatitude;
@property (nonatomic, retain) NSDecimalNumber * cityLongitude;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) Weather *weather;

@end
