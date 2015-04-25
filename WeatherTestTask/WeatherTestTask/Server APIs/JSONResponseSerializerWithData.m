//
//  JSONResponseSerializerWithData.m
//  vdiabete
//
//  Created by EugeneS on 10.04.15.
//  Copyright (c) 2015 kttsoft. All rights reserved.
//

#import "JSONResponseSerializerWithData.h"

@implementation JSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (*error != nil) {
            NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
            userInfo[JSONResponseSerializerWithDataKey] = data;
            NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
            (*error) = newError;
        }
        
        return (nil);
    }
    
    return ([super responseObjectForResponse:response data:data error:error]);
}

@end
