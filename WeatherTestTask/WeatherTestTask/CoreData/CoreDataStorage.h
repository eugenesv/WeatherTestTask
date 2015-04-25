//
//  CoreDataStorage.h
//  CoreDataDevelopment
//
//  Created by Eugene Sokolenko on 07.02.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

@class Weather, City, CustomImage, Wind;

@interface CoreDataStorage : NSObject

+ (CoreDataStorage*)sharedStorage;

//MARK: City
- (City *)addNewCityWithId:(NSNumber *)cityId
               andWithName:(NSString *)cityName
               andLatitude:(NSDecimalNumber *)latitude
              andLongitude:(NSDecimalNumber *)longitude
            andCountryName:(NSString *)countryName;

- (City *)getCityById:(NSNumber *)cityId;
- (NSArray *)getCitiesList;

//MARK: CustomImage
- (CustomImage *)addNewCustomImageWithData:(NSData *)imageData
                                forWeather:(Weather *)weather;

//MARK: Weather
- (Weather *)addNewWeatherWithTemperature:(NSDecimalNumber *)temperature
                        andMinTemperature:(NSDecimalNumber *)minTemperature
                        andMaxTemperature:(NSDecimalNumber *)maxTemperature
                           andGroundLevel:(NSDecimalNumber *)groundLevel
                              andSeaLevel:(NSDecimalNumber *)seaLevel
                              andPressure:(NSDecimalNumber *)pressure
                              andHumidity:(NSNumber *)humidity
                           andSunriseTime:(NSNumber *)sunrise
                            andSunsetTime:(NSNumber *)sunset
                                  andDate:(NSNumber *)date
                                  forCity:(City *)city;

- (Weather *)getWeatherByCity:(City *)city;
- (Weather *)addNewWeatherForCity:(City *)city;

//MARK: Wind
- (Wind *)addNewWindWithSpeed:(NSDecimalNumber *)speed
                    andDegree:(NSDecimalNumber *)degree
                 andDirection:(NSString *)direction
                    toWeather:(Weather *)weather;

- (Wind *)addNewWindForWeather:(Weather *)weather;

@end
