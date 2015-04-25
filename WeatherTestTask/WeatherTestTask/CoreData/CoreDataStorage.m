//
//  CoreDataStorage.m
//  CoreDataDevelopment
//
//  Created by Eugene Sokolenko on 07.02.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "CoreDataStorage.h"
#import "CoreDataManager.h"

#import "City.h"
#import "Weather.h"
#import "CustomImage.h"

@interface CoreDataStorage ()

@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;
@property (strong, nonatomic) CoreDataManager           *coreDataManager;

@end

@implementation CoreDataStorage

#pragma mark - Accessors

- (NSManagedObjectContext*)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[CoreDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

- (CoreDataManager *)coreDataManager {
    if (!_coreDataManager) {
        _coreDataManager = [CoreDataManager sharedManager];
    }
    return _coreDataManager;
}

+ (CoreDataStorage*)sharedStorage {
    static CoreDataStorage *storage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[CoreDataStorage alloc] init];
    });
    
    return storage;
}

#pragma mark - CoreData to SQL requests
#pragma mark - City

- (City *)addNewCityWithId:(NSNumber *)cityId
               andWithName:(NSString *)cityName
               andLatitude:(NSDecimalNumber *)latitude
              andLongitude:(NSDecimalNumber *)longitude
            andCountryName:(NSString *)countryName {
    City *city = (City *)[self.coreDataManager addNewManagedObjectForName:@"City"];
    city.cityId = cityId;
    city.cityName = cityName;
    city.cityLatitude = latitude;
    city.cityLongitude = longitude;
    city.countryName = countryName;
    [self.coreDataManager saveContext];
    return city;
}

- (City *)getCityById:(NSNumber *)cityId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId == %@", cityId];
    NSArray *cities = [self.coreDataManager getEntities:@"City" byPredicate:predicate];
    if ([cities count]) {
        return cities[0];
    }
    return nil;
}

- (NSArray *)getCitiesList {
    NSArray *cities = [self.coreDataManager getEntities:@"City"];
    return cities;
}

#pragma mark CustomImage
- (CustomImage *)addNewCustomImageWithData:(NSData *)imageData
                                forWeather:(Weather *)weather {
    CustomImage *customImage = (CustomImage *)[self.coreDataManager addNewManagedObjectForName:@"CustomImage"];
    customImage.imageData = imageData;
    weather.icon = customImage;
    [self.coreDataManager saveContext];
    return customImage;
}

#pragma mark - Weather
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
                                  forCity:(City *)city {
    Weather *weather = (Weather *)[self.coreDataManager addNewManagedObjectForName:@"Weather"];
    weather.temperature = temperature;
    weather.temperatureMin = minTemperature;
    weather.temperatureMax = maxTemperature;
    weather.groundLevel = groundLevel;
    weather.seaLevel = seaLevel;
    weather.pressure = pressure;
    weather.humidity = humidity;
    weather.sunrise = sunrise;
    weather.sunset = sunset;
    weather.weatherDate = date;
    city.weather = weather;
    [self.coreDataManager saveContext];
    return weather;
}

- (Weather *)addNewWeatherForCity:(City *)city {
    Weather *weather = (Weather *)[self.coreDataManager addNewManagedObjectForName:@"Weather"];
    city.weather = weather;
    [self.coreDataManager saveContext];
    return weather;
}

- (Weather *)getWeatherByCity:(City *)city {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city == %@", city];
    NSArray *weathers = [self.coreDataManager getEntities:@"Weather" byPredicate:predicate];
    if ([weathers count]) {
        return weathers[0];
    }
    return nil;
}

@end
