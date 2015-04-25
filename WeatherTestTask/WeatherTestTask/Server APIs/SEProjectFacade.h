//
//  SEProjectFacade.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

@class SESessionManager, SENetworkOperation, Country, Weather, City;

@interface SEProjectFacade : NSObject

+ (SESessionManager *)HTTPClient;

+ (SENetworkOperation *)getWeatherByCity:(City *)city onSuccess:(void (^)(Weather *weather))success
                               onFailure:(void (^)(NSError *error, BOOL isCanceled))failure;

@end
