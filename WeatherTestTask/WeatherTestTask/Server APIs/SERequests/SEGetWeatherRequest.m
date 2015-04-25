//
//  SEGetWeatherRequest.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "SEGetWeatherRequest.h"
#import "City.h"
#import "CoreDataStorage.h"
#import "Weather.h"
#import "Weather+UpdateWithServerResponse.h"

static NSString *requestAction = @"data/2.5/weather";
static NSString *keyCityId = @"id";
static NSString *imageAction = @"http://api.openweathermap.org/img/w/";

@implementation SEGetWeatherRequest

#pragma mark - Lifecycle

- (instancetype)initWithCity:(City *)currentCity {
    self = [super init];
    if (self) {
        
        _method = @"POST";
        _autorizationRequired = NO;
        
        _currentCity = currentCity;
        self.action = [self theRequestAction];
        
        NSDictionary *parameters = @{keyCityId: currentCity.cityId};
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError* __autoreleasing  *)error {
    
    [self fillWindAndWeatherFromResponseObject:responseObject];
    
    return YES;
}

- (NSString*)theRequestAction {
    
    return [NSString stringWithFormat:@"%@?id=%@",requestAction, self.currentCity.cityId];
}

- (void)fillWindAndWeatherFromResponseObject:(id)responseObject {
    
    NSMutableDictionary *responseWeatherDict = [NSMutableDictionary dictionary];
    
    NSDictionary *response = (NSDictionary *)responseObject;
    
    [response enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"dt"]) {
            [responseWeatherDict setObject:obj forKey:@"date"];
        }
        if ([key isEqualToString:@"main"]) {
            [responseWeatherDict addEntriesFromDictionary:obj];
        }
        if ([key isEqualToString:@"sys"]) {
            [responseWeatherDict addEntriesFromDictionary:obj];
        }
        if ([key isEqualToString:@"weather"]) {
            [responseWeatherDict addEntriesFromDictionary:obj[0]];
        }
        if ([key isEqualToString:@"wind"]) {
            [responseWeatherDict addEntriesFromDictionary:obj];
        }
    }];
    
    //create and update current weather
    self.currentWeather = [[CoreDataStorage sharedStorage] addNewWeatherForCity:self.currentCity];
    [self.currentWeather updateWithServerResponse:responseWeatherDict];
    
    //get image data for weather icon
    NSString *iconPath = responseWeatherDict[@"icon"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageAction, iconPath]]];
    
    [[CoreDataStorage sharedStorage] addNewCustomImageWithData:imageData forWeather:self.currentWeather];
}

@end
