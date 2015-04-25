//
//  SEProjectFacade.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "SEProjectFacade.h"
#import "SESessionManager.h"

#import "ProjectGlobals.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static SESessionManager *sharedHTTPClient = nil;

//static NSString *baseURLString = @"http://5.9.156.3/~gosti/api/";
//static NSString *baseURLString = @"http://5.9.156.3/~karicom/app-new/index.php?r=api/";
//static NSString *baseURLString = @"http://192.168.1.13/vdiabete/basic/web/index.php?r=api/"; //Kostya
static NSString *baseURLString = @"http://192.168.1.105/vdiabete/basic/web/api/"; //Yura

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

+ (NSString*)deviceUDIDString {
    NSUUID *deviceUDID=  [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"%@",deviceUDID);
    return [deviceUDID UUIDString];
}

+ (void)storeToken:(NSString*)tokenString {
    [[self HTTPClient] storeAuthData:tokenString];
}

@end
