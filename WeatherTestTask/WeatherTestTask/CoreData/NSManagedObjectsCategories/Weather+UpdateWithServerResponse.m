//
//  Weather+UpdateWithServerResponse.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "Weather+UpdateWithServerResponse.h"
#import "Constants.h"

@implementation Weather (UpdateWithServerResponse)

- (instancetype)updateWithServerResponse:(NSDictionary *)response {
    if (self) {
        self.temperature        = [self celciusFromKelvin:[response[keyTemperature] floatValue]];
        self.temperatureMax     = [self celciusFromKelvin:[response[keyTemperatureMax] floatValue]] ;
        self.temperatureMin     = [self celciusFromKelvin:[response[keyTemperatureMin] floatValue]];
        self.pressure           = response[keyPressure];
        self.seaLevel           = response[keySeaLevel];
        self.groundLevel        = response[keyGroundLevel];
        self.sunrise            = response[keySunrise];
        self.sunset             = response[keySunset];
        self.humidity           = response[keyHumidity];
        self.windSpeed          = response[keySpeed];
        self.windDegree         = response[keyDegree];
        self.weatherDescription = response[@"description"];
        self.weatherDate        = @([[NSDate date] timeIntervalSince1970]);//response[@"date"];
    }
    return self;
}

- (NSDecimalNumber *)celciusFromKelvin:(CGFloat)farengheit {
    CGFloat result = farengheit - 273.15f;
    NSDecimalNumber *celcius = [[NSDecimalNumber alloc] initWithFloat:result];
    return celcius;
}

@end
