//
//  Wind.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weather;

@interface Wind : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * speed;
@property (nonatomic, retain) NSString * windDescription;
@property (nonatomic, retain) NSString * direction;
@property (nonatomic, retain) NSDecimalNumber * degree;
@property (nonatomic, retain) Weather *weather;

@end
