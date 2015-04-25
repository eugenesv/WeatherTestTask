//
//  SEProjectFacade.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "SEProjectFacade.h"
#import "SESessionManager.h"

#import "SEGetWeatherRequest.h"
#import "Weather.h"

#import "ProjectGlobals.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static SESessionManager *sharedHTTPClient = nil;

static NSString *baseURLString = @"http://api.openweathermap.org/"; //openweather

@implementation SEProjectFacade

#pragma mark - Singletone init

+ (SESessionManager *)HTTPClient {
    if (!sharedHTTPClient) {
        [SEProjectFacade initHTTPClientWithRootPath:baseURLString];
//        [RMCoreDataStorage sharedInstance];
    }
    return sharedHTTPClient;
}

#pragma mark - Lifecycle

+ (void)initHTTPClientWithRootPath:(NSString*)baseURL {
    if (sharedHTTPClient) {
        
        [sharedHTTPClient cleanManagersWithCompletionBlock:^{
            sharedHTTPClient = nil;
            AFNetworkActivityIndicatorManager.sharedManager.enabled = NO;
            sharedHTTPClient = [[SESessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
            //            sharedHTTPClient.redirectDelegate = redirectDelegate;
            AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        }];
    } else {
        sharedHTTPClient = [[SESessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    }
}

#pragma mark - Actions

+ (BOOL)checkReachabilityStatus {
    return [sharedHTTPClient checkReachabilityStatus];
}

+ (void)checkReachabilityStatusWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    return [sharedHTTPClient checkReachabilityStatusWithSuccess:success failure:failure];
}

+ (void)cancelAllOperationWithType:(NSString*)requestType {
    return [sharedHTTPClient cancelAllOperationWithType:requestType];
}

+ (SENetworkOperation*)renewSessionTokenWithSuccessBlock:(void (^)())success
                                                 failure:(void (^)(NSError *error, BOOL isCanceled))failure {
    return [sharedHTTPClient renewSessionTokenWithSuccessBlock:success failure:failure];
}

#pragma mark - Requests builder

+ (SENetworkOperation *)getWeatherByCity:(City *)city onSuccess:(void (^)(Weather *weather))success
                                        onFailure:(void (^)(NSError *error, BOOL isCanceled))failure {
    
    SEGetWeatherRequest *request = [[SEGetWeatherRequest alloc] initWithCity:city];
    
    SENetworkOperation *operation = [[self HTTPClient] enqueueOperationWithNetworkRequest:request success:^(SENetworkOperation *operation) {
        SEGetWeatherRequest *request = (SEGetWeatherRequest*)operation.networkRequest;
        success(request.currentWeather);
    } failure:^(NSError *error, BOOL isCanceled) {
        ShowErrorAlert(error);
        failure(error, isCanceled);
    }];
    return operation;
}

+ (NSString*)deviceUDIDString {
    NSUUID *deviceUDID=  [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"%@",deviceUDID);
    return [deviceUDID UUIDString];
}

+ (void)storeToken:(NSString*)tokenString {
    [[self HTTPClient] storeAuthData:tokenString];
}

@end
