//
//  CustomImage.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 26.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weather;

@interface CustomImage : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) Weather *weather;

@end
