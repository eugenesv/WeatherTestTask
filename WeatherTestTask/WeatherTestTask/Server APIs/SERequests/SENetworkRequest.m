//
//  SENetworkRequest.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "SENetworkRequest.h"
#import "Constants.h"

static NSString *routeKey   = @"route";
static NSString *actionKey  = @"action";
static NSString *dataKey    = @"data";
static NSString *paramsKey  = @"params";
static NSString *tokenKey   = @"token";


@implementation SENetworkRequest

#pragma mark - Lifecycle

-(id)init {
    if (self = [super init]) {
        
        _path = @"";
        if (!_parameters) {
            _parameters = [NSMutableDictionary dictionary];
        }
        if(!_customHeaders) {
            _customHeaders = [NSMutableDictionary dictionary];
        }
        if(!_files) {
            _files = [NSMutableArray array];
        }
    }
    return self;
}

-(void)dealloc {
    _error = nil;
}

- (BOOL)setParametersWithParamsData:(NSDictionary*)data {
    return [self setParametersWithRoute:self.route andAction:self.action andParamsData:data];
}

- (BOOL)setParametersWithRoute:(NSString*)route andAction:(NSString*)action andParamsData:(NSDictionary*)data {
    if (!action) {
        return NO;
    }
    //    _parameters=[NSMutableDictionary dictionary];
    //    NSMutableDictionary *paramsDict=[NSMutableDictionary dictionary];
    //    if (data)
    //    {
    //        [paramsDict setObject:data forKey:dataKey];
    //    }
    //    [_parameters setObject:paramsDict forKey:paramsKey];
    _parameters = [NSMutableDictionary dictionaryWithDictionary:data];
    _path = action;
    return YES;
}

- (BOOL)setToken:(NSString*)token {
    
    if (!token || ![token length] || !self.parameters) {
        return NO;
    }
    
    [self.parameters setObject:token forKey:tokenKey];
    return YES;
}

- (BOOL)parseResponseSucessfully:(id)responseObject {
    
    BOOL parseJSONData = NO;
    
    if (responseObject == nil) {
        LOG_NETWORK(@"Error: Response Is Empty");
        _error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@ - response is empty", NSStringFromClass([self class])]
                                     code:1
                                 userInfo:@{NSLocalizedDescriptionKey: @"response empty"}];
        
        return parseJSONData;
    }
    
    NSError* error = nil;
    NSDictionary* json;
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        
        json = [NSJSONSerialization
                JSONObjectWithData:responseObject
                options:kNilOptions
                error:&error];
    }
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        json = responseObject;
    }
    
    NSLog(@"%@",json);
    
    if (error) {
        _error = error;
    } else {
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            id statusCode;
            if ([json[keyStatusCode] isKindOfClass:[NSNumber class]]) {
                
            } else if ([json[keyStatusCode] isKindOfClass:[NSString class]]) {
                
            }
            
            if([json[keyStatusCode] isEqualToNumber:@200]) {
                
                @try {
                    NSError* error = nil;
                    parseJSONData = [self parseJSONDataSucessfully:json error:&error];
                    if (!_error) {
                        _error = error;
                    }
                }
                @catch (NSException * exception) {
                    _error = [NSError errorWithDomain:@""
                                                 code:3
                                             userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"name:%@\nreason:%@", exception.name, exception.reason]}];
                }
                @finally {
                    
                }
            } else {
                
                [self createErrorWithResponseObject:json];
                
            }
        } else {
            
        }
    }
    
    return parseJSONData;
}

- (void)createErrorWithResponseObject:(NSDictionary*)responseObject {
    
    NSInteger code = 0;
    NSString* description = @"";
    
    if (responseObject[keyStatusCode]) {
        code = [responseObject[keyStatusCode] integerValue];
    }
    
    //        if([self validateJsonErrorObject:responseObject withKey:@"general"]) {
    //            description = responseObject[@"meta"][@"description"][@"general"][0];
    //        }
    if (responseObject[keyMessage] && [responseObject[keyMessage] isKindOfClass:[NSString class]]) {
        description =responseObject[keyMessage];
    }
    
    _error = [NSError errorWithDomain:keyMessage
                                 code:code
                             userInfo:@{NSLocalizedDescriptionKey: description}];
    
}

- (BOOL)validateJsonErrorObject:(id)object withKey:(NSString*)key {
    
    if ([object[@"meta"][@"description"] isKindOfClass:[NSDictionary class]] && object[@"meta"][@"description"][key] && [object[@"meta"][@"description"][key] isKindOfClass:[NSArray class]] && ((NSArray*)object[@"meta"][@"description"][key]).count > 0 && [[((NSArray*)object[@"meta"][@"description"][key]) firstObject] isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError* __autoreleasing  *)error {
    return YES;
}

- (BOOL)prepareAndCheckRequestParameters {
    return YES;
}

@end