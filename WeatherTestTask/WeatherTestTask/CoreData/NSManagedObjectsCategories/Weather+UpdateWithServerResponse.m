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
        self.temperature        = response[keyTemperature];
        self.temperatureMax     = response[keyTemperatureMax];
        self.temperatureMin     = response[keyTemperatureMin];
        self.pressure           = response[keyPressure];
        self.seaLevel           = response[keySeaLevel];
        self.groundLevel        = response[keyGroundLevel];
        self.sunrise            = response[keySunrise];
        self.sunset             = response[keySunset];
        self.humidity           = response[keyHumidity];
        self.windSpeed          = response[keySpeed];
        self.windDegree         = response[keyDegree];
        self.weatherDate        = @([[NSDate date] timeIntervalSince1970]);//response[@"date"];
    }
    return self;
}

@end
