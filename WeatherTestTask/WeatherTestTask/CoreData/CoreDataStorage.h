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
- (Weather *)getWeatherByCity:(City *)city;
- (Weather *)addNewWeatherForCity:(City *)city;
- (NSArray *)allWeathers;

@end
