//
//  SENetworkOperation.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "SENetworkRequest.h"

@interface SENetworkOperation : NSObject

typedef void (^SuccessBlock)(SENetworkOperation* operation);
typedef void (^FailureBlock)(NSError* error, BOOL isCanceled);
typedef void (^FailureBlockWithOperation)(SENetworkOperation* operation, NSError* error, BOOL isCanceled);
typedef void (^ProgressBlock)(SENetworkOperation* operation, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);

- (id)initWithNetworkRequest:(SENetworkRequest*)networkRequest networkManager:(id)manager error:(NSError *__autoreleasing *)error;
- (void)setCompletionBlockAfterProcessingWithSuccess:(SuccessBlock)success
                                             failure:(FailureBlockWithOperation)failure;
- (void)setProgressBlock:(ProgressBlock)block;

- (void)start;
- (void)pause;
- (void)cancel;

@property (strong, nonatomic)                   NSDictionary                          *allHeaders;
@property (strong, nonatomic, readonly)         SENetworkRequest                      *networkRequest;
@property (copy, nonatomic)                     SuccessBlock                          successBlock;
@property (copy, nonatomic)                     FailureBlockWithOperation             failureBlock;

@end
