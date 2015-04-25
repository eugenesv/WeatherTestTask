//
//  SENetworkRequest.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

@interface SENetworkRequest : NSObject {
    NSString*						_path;
    NSMutableDictionary*			_parameters;
    NSString*						_method;
    NSMutableDictionary*            _customHeaders;
    BOOL                            _autorizationRequired;
    NSError*                        _error;
}

@property (strong, nonatomic, readonly)     NSString            *path;
@property (strong, nonatomic, readonly)     NSMutableDictionary *parameters;
@property (strong, nonatomic, readonly)     NSString            *method;
@property (strong, nonatomic, readonly)     NSMutableDictionary *customHeaders;
@property (assign, nonatomic, readonly)     BOOL                autorizationRequired;
@property (strong, nonatomic, readonly)     NSMutableArray      *files;
@property (strong, nonatomic)               NSError             *error;
@property (strong, nonatomic)               NSString            *route;
@property (strong, nonatomic)               NSString            *action;

- (BOOL)prepareAndCheckRequestParameters;
- (BOOL)parseResponseSucessfully:(id)responseObject;
- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError* __autoreleasing *)error;
- (void)createErrorWithResponseObject:(NSDictionary*)responseObject;
- (BOOL)validateJsonErrorObject:(id)object withKey:(NSString*)key;

- (BOOL)setParametersWithRoute:(NSString*)route andAction:(NSString*)action andParamsData:(NSDictionary*)data;
- (BOOL)setParametersWithParamsData:(NSDictionary*)data;

- (BOOL)setToken:(NSString*)token;

@end
