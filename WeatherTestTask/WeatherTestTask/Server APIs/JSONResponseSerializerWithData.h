//
//  JSONResponseSerializerWithData.h
//  vdiabete
//
//  Created by EugeneS on 10.04.15.
//  Copyright (c) 2015 kttsoft. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer

@end
