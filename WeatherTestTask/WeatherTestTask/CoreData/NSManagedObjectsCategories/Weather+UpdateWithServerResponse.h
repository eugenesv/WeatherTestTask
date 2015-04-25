//
//  Weather+UpdateWithServerResponse.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "Weather.h"

@interface Weather (UpdateWithServerResponse)

- (instancetype)updateWithServerResponse:(NSDictionary *)response;

@end
