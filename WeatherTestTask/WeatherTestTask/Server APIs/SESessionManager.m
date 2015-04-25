//
//  SESessionManager.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#define TOKEN_EXPIRED_TIME 86400.f
#define MAX_CONCURENT_REQUESTS 100
#define ALL_CLEANS_COUNT 1

#import "SESessionManager.h"
#import "SENetworkOperation.h"
#import <AFNetworking.h>
#import "Constants.h"
#import "JSONResponseSerializerWithData.h"

@interface SESessionManager ()

@property (strong, nonatomic) CleanBlock                    cleanBlock;

@property (strong, nonatomic) AFHTTPSessionManager          *sessionManager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@property (assign, nonatomic) AFNetworkReachabilityStatus   reachabilityStatus;

@property (strong, readwrite, nonatomic) NSURL              *baseURL;

@property (strong, nonatomic) NSMutableArray                *operationQueue;

@property (strong, nonatomic) NSMutableArray                *requestStack;
@property (strong, nonatomic) NSMutableArray                *failStack;

@property (assign, nonatomic) NSUInteger                    cleanCount;

@property (strong, nonatomic) NSLock                        *lock;

@property (assign, nonatomic, readwrite) BOOL               autoLoginKey;

@property (assign, nonatomic) BOOL                          wasRedirectToStartInSession;

@end

@implementation SESessionManager

#pragma mark - Init methods

- (id)initWithBaseURL:(NSURL*)url {
    
    if (self = [super init]) {
        
        self.baseURL = url;
        
        if ([NSURLSession class]) {
            NSURLSessionConfiguration* taskConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            taskConfig.HTTPMaximumConnectionsPerHost = MAX_CONCURENT_REQUESTS;
            taskConfig.timeoutIntervalForRequest = 0;
            taskConfig.timeoutIntervalForResource = 0;
            taskConfig.allowsCellularAccess = YES;
            _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:taskConfig];
            [_sessionManager setResponseSerializer:[JSONResponseSerializerWithData serializer]];
        } else {
            _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
            
            [_operationManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
            _operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"image/jpeg", @"image/png", nil];
        }
        
        self.lock = [[NSLock alloc] init];
        self.lock.name = @"CleanSessionLock";
        self.operationQueue = [NSMutableArray array];
        self.wasRedirectToStartInSession = NO;
        
        self.operationQueue = [NSMutableArray array];
        __weak typeof(self)weakSelf = self;
        
        self.requestStack = [NSMutableArray array];
        self.failStack = [NSMutableArray array];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        weakSelf.reachabilityStatus=[[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachabilityStatus = status;
            
#ifdef DEBUG
            NSString* stateText = nil;
            switch (weakSelf.reachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown:
                    stateText = @"Network reachability is unknown";
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    stateText = @"Network is not reachable";
                    if (!weakSelf.isNetworkReachabilityStatusAlertHidden) {
                    }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    stateText = @"Network is reachable via WWAN";
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    stateText = @"Network is reachable via WiFi";
                    break;
            }
#endif
            
        }];
        
        self.autoLoginKey = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLoginKey"];
        self.accessTokenKeyExpiredAt = [[NSUserDefaults standardUserDefaults] objectForKey:@"exp_date"];
        self.requestNumber = 0;
        
//        [self loadClientData];
    }
    return self;
}

-(void)cleanManagersWithCompletionBlock:(CleanBlock)block {
    if ([NSURLSession class]) {
        self.cleanCount = 0;
        self.cleanBlock = block;
        __weak typeof(self)weakSelf = self;
        [_sessionManager setSessionDidBecomeInvalidBlock:^(NSURLSession *session, NSError *error) {
            [weakSelf syncCleans];
            weakSelf.sessionManager = nil;
        }];
        [_sessionManager invalidateSessionCancelingTasks:YES];
    } else {
        _operationManager = nil;
        if (block) {
            block();
        }
    }
}

-(void)syncCleans {
    [self.lock lock];
    self.cleanCount++;
    [self.lock unlock];
    if (self.cleanCount == ALL_CLEANS_COUNT) {
        if (self.cleanBlock) {
            self.cleanBlock();
        }
    }
}

-(id)manager {
    if (_sessionManager) {
        return _sessionManager;
    } else if (_operationManager) {
        return _operationManager;
    }
    return nil;
}

-(void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - Public methods

- (BOOL)isSessionValidWithAutologin {
    if (self.accessTokenKey && self.autoLoginKey && ([[NSDate date] compare:self.accessTokenKeyExpiredAt] == NSOrderedAscending)) {
        return YES;
    }
    return NO;
}

- (BOOL)isSessionValid {
    if (self.accessTokenKey && ([[NSDate date] compare: self.accessTokenKeyExpiredAt] == NSOrderedAscending)) {
        return YES;
    }
    return NO;
}

- (void)storeAuthData:(NSString *)accessToken autoLoginKey:(NSString *)autoLoginKey {
    self.accessTokenKey = accessToken;
    self.autoLoginKey = autoLoginKey;
    if (accessToken && autoLoginKey) {
        self.accessTokenKeyExpiredAt = [NSDate dateWithTimeIntervalSinceNow:TOKEN_EXPIRED_TIME];
        self.wasRedirectToStartInSession = NO;
    }
    [self saveClientData];
}

- (void)saveClientData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"autologin key %i", self.autoLoginKey);
    [defaults setBool:self.autoLoginKey forKey:@"AutoLoginKey"];
    [defaults setObject:self.accessTokenKeyExpiredAt forKey:@"exp_date"];
    [defaults synchronize];
}

- (BOOL)checkReachabilityStatus {
    if (self.reachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

- (void)checkReachabilityStatusWithSuccess:(void (^)(void))success
                                   failure:(void (^)(NSError *error))failure {
    if (self.reachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failure) {
            NSError* error = [NSError errorWithDomain:@"Reachability."
                                                 code:2
                                             userInfo:nil];
//            @{NSLocalizedDescriptionKey: [PHUtility localizedStringForKey:@"noInternetConnection"]}
            failure(error);
        }
    } else {
        if (success) {
            success();
        }
    }
}

- (SENetworkOperation *)renewSessionTokenWithSuccessBlock:(void (^)())success
                                                 failure:(void (^)(NSError *error, BOOL isCanceled))failure {
    if (!self.autoLoginKey) {
        NSError *error = [NSError errorWithDomain:@"Session keys is missed" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Session keys is missed. Relogin is required"}];
        //        [self performRedirectToStartWithError:&error];
        if (failure) {
            failure(error, NO);
        }
        return nil;
    }
    
    __weak typeof(self)weakSelf = self;
//    PHTokenRenewRequest* tokenRequest = [[PHTokenRenewRequest alloc] initWithRefreshToken:weakSelf.autoLoginKey];
    SENetworkOperation* operation = [self enqueueOperationWithNetworkRequest:nil success:^(SENetworkOperation *operation) {
//        [weakSelf storeAuthData:((PHTokenRenewRequest*)operation.networkRequest).accessToken autoLoginKey:weakSelf.autoLoginKey];
        if (success) {
            success();
        }
    } failure:failure];
    return operation;
}

#pragma mark - Operation cycle

- (SENetworkOperation*)enqueueOperationWithNetworkRequest:(SENetworkRequest*)networkRequest success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure {
    NSError* error = nil;
    id manager = nil; //[AFHTTPSessionManager manager];
    
    if ([NSURLSession class]) {
        manager = _sessionManager;
    } else {
        manager = _operationManager;
    }
    
    SENetworkOperation* operation = [[SENetworkOperation alloc] initWithNetworkRequest:networkRequest networkManager:manager error:&error];
    
    __weak typeof(self)weakSelf = self;
    
    if ((error) && (failure)) {
        
        failure(error, NO);
        
    } else {
        
        [self enqueueOperation:operation success:^(SENetworkOperation *operation) {
            
            if (success) {
                success(operation);
            }
            
            [weakSelf finishOperationInQueue:operation];
            
        } failure:^(SENetworkOperation *operation, NSError *error, BOOL isCanceled) {
            
            if ([error.domain isEqualToString:@"redirect"]) {
                
            }
            
            [weakSelf finishOperationInQueue:operation];
            
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    }
    
    return operation;
}

- (void)enqueueOperation:(SENetworkOperation*)operation success:(SuccessBlock)success
                 failure:(FailureBlockWithOperation)failure {
    
    __weak typeof(self)weakSelf = self;
    [self checkReachabilityStatusWithSuccess:^() {
        
        [operation setCompletionBlockAfterProcessingWithSuccess:success failure:failure];
        
        //        if (operation.networkRequest.autorizationRequired && ![weakSelf isSessionValid])
        //        {
        //        }
        //        else
        //        {
        [weakSelf addOperationToQueue:operation];
        //        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(operation, error, NO);
        }
    }];
}

- (void)cancelAllOperations {
    if ([NSURLSession class]) {
        [self.sessionManager.operationQueue cancelAllOperations];
    } else {
        [self.operationManager.operationQueue cancelAllOperations];
    }
}

- (void)finishOperationInQueue:(SENetworkOperation*)operation {
    [self.operationQueue removeObject:operation];
}

- (void)addOperationToQueue:(SENetworkOperation*)operation {
    [self.operationQueue addObject:operation];
    [operation start];
}

- (void)storeAuthData:(NSString *)accessToken {
    self.accessTokenKey = accessToken;
    [self saveClientData];
//    [[PDKeychainBindings sharedKeychainBindings] setString:accessToken forKey:keyAccessToken];
}

@end
