//
//  SENetworkOperation.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#define TOKEN_EXPIRED_TIME 86400.f

#import "SENetworkOperation.h"
#import "SENetworkRequest.h"
#import "SEProjectFacade.h"
#import "SESessionManager.h"

NS_CLASS_AVAILABLE(10_9, 7_0)
@interface DataTask : NSURLSessionDataTask @end

NS_CLASS_AVAILABLE(10_9, 7_0)
@interface UploadTask : NSURLSessionUploadTask @end

NS_CLASS_AVAILABLE(10_9, 7_0)
@interface DownloadTask : NSURLSessionDownloadTask @end

@interface SENetworkOperation ()

@property (strong, nonatomic, readwrite) SENetworkRequest   *networkRequest;
@property (strong, nonatomic) NSMutableURLRequest           *urlRequest;

@property (nonatomic, strong) AFHTTPRequestOperation        *operation;
@property (strong, nonatomic) DataTask                      *dataTask;
@property (strong, nonatomic) DownloadTask                  *downloadTask;
@property (strong, nonatomic) UploadTask                    *uploadTask;

@property (weak, nonatomic) id networkManager;

@property (strong, nonatomic, readwrite) NSProgress         *progress;
@property (strong, nonatomic) ProgressBlock                 progressBlock;

@property (assign, nonatomic) NSUInteger                    requestNumber;

@end

@implementation SENetworkOperation

- (id)initWithNetworkRequest:(SENetworkRequest*)networkRequest networkManager:(id)manager error:(NSError *__autoreleasing *)error {
    
    BOOL passedParametersCheck = [networkRequest prepareAndCheckRequestParameters];
    
    
    if (!passedParametersCheck) {
        if (!networkRequest.error) {
            networkRequest.error = [NSError errorWithDomain:@"Internal inconsistency"
                                                       code:3
                                                   userInfo:@{NSLocalizedDescriptionKey: @"Parameters didn't pass validation."}];
        }
        LOG_NETWORK(@"ERROR: parameters didn't pass check. Aborting operation.");
        
        if(error) {
            *error = networkRequest.error;
        }
        
        return (self = [super init]);
    }
    
    self.urlRequest = nil;
    AFHTTPRequestSerializer* serializer = nil;
    
    if ([NSURLSession class]) {
        NSAssert([manager isKindOfClass:[AFHTTPSessionManager class]], nil);
        AFHTTPSessionManager *networkManager = manager;
        serializer = networkManager.requestSerializer;
    } else {
        AFHTTPRequestOperationManager *networkManager = manager;
        serializer = networkManager.requestSerializer;
    }
    
    //    if([SEProjectFacade HTTPClient].accessTokenKey && networkRequest.autorizationRequired )
    //    {
    //        if (![networkRequest setToken:[RMPocketGuardFacade HTTPClient].accessTokenKey])
    //        {
    //            LOG_GENERAL(@"Token is invalid");
    //        }
    //
    //    }
    
    if ([networkRequest.files count] > 0) {
        self.urlRequest = [serializer  multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:networkRequest.path relativeToURL:[SEProjectFacade HTTPClient].baseURL] absoluteString] parameters:networkRequest.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [networkRequest.files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            }];
            
        } error:error];
    } else {

        self.urlRequest = [serializer requestWithMethod:networkRequest.method
                                              URLString:[NSString stringWithFormat:@"%@%@", [SEProjectFacade HTTPClient].baseURL, networkRequest.path]
                                             parameters:networkRequest.parameters
                                                  error:error];
    }
    if (*error) {
        LOG_NETWORK(@"ERROR: serialize request: %@", [*error localizedDescription]);
        return (self = [super init]);
    }
    
    if ([SEProjectFacade HTTPClient].accessTokenKey && networkRequest.autorizationRequired) {
        [self.urlRequest addValue:[SEProjectFacade HTTPClient].accessTokenKey forHTTPHeaderField:@"Authorization"];
    }
    
    
    [self.urlRequest setHTTPShouldHandleCookies:NO];
    
    __weak typeof(self)weakSelf = self;
    
    [networkRequest.customHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [weakSelf.urlRequest addValue:obj forHTTPHeaderField:key];
    }];
    
    if ((self = [super init])) {
        
        self.networkManager = manager;
        self.networkRequest = networkRequest;
        
        __weak SENetworkOperation *weakself = self;
        
        void (^SuccessOperationBlock)(id operation, id responseObject) = ^(id operation, id responseObject) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [SEProjectFacade HTTPClient].accessTokenKeyExpiredAt = [NSDate dateWithTimeIntervalSinceNow:TOKEN_EXPIRED_TIME];
            [defaults setObject:[SEProjectFacade HTTPClient].accessTokenKeyExpiredAt forKey:@"AccessTokenKeyExpiredAt"];
            [defaults synchronize];
            
            BOOL success = NO;
            
            success = [weakself.networkRequest parseResponseSucessfully:responseObject];
            
            if (success) {
                if (weakself.successBlock) {
                    weakself.successBlock(weakself);
                }
            }
            else {
                if (weakself.failureBlock) {
                    weakself.failureBlock(weakself, weakself.networkRequest.error, NO);
                }
            }
        };
        
        void (^FailureOperationBlock)(id operation, NSError *error) = ^(id operation, NSError *error) {
            BOOL requestCanceled = NO;
            
            if (error.code == 500 || error.code == 404 || error.code == -1011) {
                NSString* path = @"";
                
                if ([operation isKindOfClass:[NSURLResponse class]]) {
                    path = [((NSURLResponse*)operation).URL path];
                } else {
                    path = [((AFHTTPRequestOperation *)operation).request.URL path];
                }
                LOG_NETWORK(@"STATUS: request %@ failed with error: %@", path, [error localizedDescription]);
                weakself.networkRequest.error = [NSError errorWithDomain:error.domain
                                                                    code:error.code
                                                                userInfo:nil];
//                @{NSLocalizedDescriptionKey: [SEUtilityFunctions localizedStringForKey:@"serverIsOnMaintenance" withDefault:error.localizedDescription]};
            } else if (error.code == NSURLErrorCancelled) {
                weakself.networkRequest.error = error;
                requestCanceled = YES;
            } else {
                weakself.networkRequest.error = error;
            }
            if (weakself.failureBlock) {
                weakself.failureBlock(weakself, weakself.networkRequest.error, requestCanceled);
            }
        };
        
        if ([NSURLSession class]) {
            NSAssert([manager isKindOfClass:[AFHTTPSessionManager class]], nil);
            
            AFHTTPSessionManager *networkManager = manager;
            
            if ([self.networkRequest.files count] > 0) {
                NSProgress* progress;
                _uploadTask = (UploadTask*)[networkManager uploadTaskWithStreamedRequest:self.urlRequest progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (!error) {
                        SuccessOperationBlock(response, responseObject);
                    } else {
                        FailureOperationBlock(response, error);
                    }
                }];
                _progress = progress;
            }
            
            //        if ([self.networkRequest isKindOfClass:[PHImageDownloadRequest class]]) {
            //                NSProgress* progress;
            //                _downloadTask = (DownloadTask*)[networkManager downloadTaskWithRequest:self.urlRequest progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            //                    NSFileManager *fileManager = [NSFileManager defaultManager];
            //                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            //                    NSString* path = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[[targetPath path] componentsSeparatedByString:@"/"] lastObject]]];
            //                    NSError* error = nil;
            //                    [fileManager moveItemAtPath:[targetPath path] toPath:path error:&error];
            //
            //                    if (error) {
            //                        LOG_GENERAL(@"FILE MOVE ERROR = %@", error.localizedDescription);
            //                    }
            //                    return [NSURL fileURLWithPath:path];
            //                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //                    if (!error) {
            //                        SuccessOperationBlock(response, filePath);
            //                    } else {
            //                        FailureOperationBlock(response, error);
            //                    }
            //                }];
            //                _progress = progress;
            //            }
            
            else {
                _dataTask = (DataTask *)[networkManager dataTaskWithRequest:self.urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (!error) {
                        SuccessOperationBlock(response, responseObject);
                    } else {
                        FailureOperationBlock(response, error);
                    }
                }];
            }
            
        } else {
            NSAssert([manager isKindOfClass:[AFHTTPRequestOperationManager class]], nil);
            AFHTTPRequestOperationManager *networkManager = manager;
            _operation = [networkManager HTTPRequestOperationWithRequest:self.urlRequest success:SuccessOperationBlock failure:FailureOperationBlock];
        }
    }
    return self;
}

-(void)dealloc {
    if (_progressBlock) {
        if (_uploadTask) {
            [_uploadTask removeObserver:self forKeyPath:@"countOfBytesSent" context:NULL];
        } else if(_downloadTask) {
            [_downloadTask removeObserver:self forKeyPath:@"countOfBytesReceived" context:NULL];
        }
    }
}

- (void)setCompletionBlockAfterProcessingWithSuccess:(SuccessBlock)success
                                             failure:(FailureBlockWithOperation)failure {
    self.successBlock   = success;
    self.failureBlock   = failure;
}

-(void)printRequestData:(NSURLRequest*)request withNumber:(NSInteger)number {
    LOG_NETWORK(@"Request >>> : %li \n%@\nmethod - %@\n%@\nHeaders\n%@",
                (long)number,
                request.URL.absoluteString,
                request.HTTPMethod,
                [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding],
                request.allHTTPHeaderFields);
}

#pragma mark - Public methods

- (NSDictionary *)allHeaders {
    _allHeaders = [self.operation.responseObject allHeaderFields];
    return _allHeaders;
}

- (void)setProgressBlock:(ProgressBlock)block {
    if (block) {
        if (_uploadTask) {
            _progressBlock = block;
            [_uploadTask addObserver:self forKeyPath:@"countOfBytesSent" options:NSKeyValueObservingOptionNew context:NULL];
        } else if (_downloadTask) {
            _progressBlock = block;
            [_downloadTask addObserver:self forKeyPath:@"countOfBytesReceived" options:NSKeyValueObservingOptionNew context:NULL];
        } else {
            __weak typeof(self)weakSelf = self;
            if (self.networkRequest.files.count > 0) {
                [_operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    block(weakSelf, totalBytesWritten, totalBytesExpectedToWrite);
                }];
            }
        }
    }
}

- (void)start {
    if (_dataTask) {
        [_dataTask resume];
    } else if (_operation) {
        [_operation start];
    } else if (_uploadTask) {
        [_uploadTask resume];
    } else if (_downloadTask) {
        [_downloadTask resume];
    }
    if (!_downloadTask) {
        [SEProjectFacade HTTPClient].requestNumber++;
        self.requestNumber = [SEProjectFacade HTTPClient].requestNumber;
        [self printRequestData:self.urlRequest withNumber:self.requestNumber];
    }
}

- (void)pause {
    if (_dataTask) {
        [_dataTask suspend];
    } else if (_operation) {
        [_operation pause];
    } else if (_uploadTask) {
        [_uploadTask suspend];
    } else if (_downloadTask) {
        [_downloadTask suspend];
    }
}

-(void)cancel {
    if (_dataTask) {
        [_dataTask cancel];
    } else if (_operation) {
        [_operation cancel];
    } else if (_uploadTask) {
        [_uploadTask cancel];
    } else if (_downloadTask) {
        [_downloadTask cancel];
    }
}

#pragma mark - Progress observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    id newValue = change[NSKeyValueChangeNewKey];
    
    if (![newValue isEqual:[NSNull null]] && [newValue isKindOfClass:[NSNumber class]] && self.progressBlock) {
        
        NSInteger bytesSend = 0;
        NSInteger totalBytesSend = 0;
        if (_uploadTask) {
            bytesSend = _uploadTask.countOfBytesSent;
        } else if (_downloadTask) {
            bytesSend = (NSInteger)_downloadTask.countOfBytesReceived;
            totalBytesSend = (NSInteger)_downloadTask.countOfBytesExpectedToReceive;
        }
        if(bytesSend > totalBytesSend) {
            bytesSend = totalBytesSend;
        }
        //        NSLog(@"%@ + %ld + %ld", self, (long)bytesSend, (long)totalBytesSend);
        self.progressBlock(self, bytesSend, totalBytesSend);
    }
}

@end