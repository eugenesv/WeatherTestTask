//
//  City+Annotation.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "City+Annotation.h"

@implementation City (Annotation)

- (NSString *)title {
    return self.cityName;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.latitude = [self.cityLatitude doubleValue];
    coord.longitude = [self.cityLongitude doubleValue];
    return coord;
}

@end
