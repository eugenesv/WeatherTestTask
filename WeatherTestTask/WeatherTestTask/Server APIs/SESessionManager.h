//
//  SESessionManager.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "SENetworkOperation.h"

typedef void (^CleanBlock)();

@interface SESessionManager : NSObject

@property (assign, nonatomic) BOOL isNetworkReachabilityStatusAlertHidden;

@property (strong, nonatomic, readwrite) NSDate         *accessTokenKeyExpiredAt;
@property (strong, nonatomic, readwrite) NSString       *accessTokenKey;
@property (assign, atomic) NSInteger                    requestNumber;

@property (strong, nonatomic, readonly) NSURL           *baseURL;

- (id)initWithBaseURL:(NSURL*)url;

- (BOOL)isSessionValid;
- (BOOL)isSessionValidWithAutologin;

- (BOOL)checkReachabilityStatus;
- (void)checkReachabilityStatusWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)storeAuthData:(NSString *)accessToken;
- (void)saveClientData;
- (void)cancelAllOperationWithType:(NSString*)requestType;
- (void)cancelAllOperations;
- (void)cleanManagersWithCompletionBlock:(CleanBlock)block;
- (SENetworkOperation*)renewSessionTokenWithSuccessBlock:(void (^)())success
                                                 failure:(void (^)(NSError *error, BOOL isCanceled))failure;

- (void)enqueueOperation:(SENetworkOperation*)operation success:(SuccessBlock)success
                 failure:(FailureBlockWithOperation)failure;
- (SENetworkOperation*)enqueueOperationWithNetworkRequest:(SENetworkRequest*)networkRequest success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure;

@end
