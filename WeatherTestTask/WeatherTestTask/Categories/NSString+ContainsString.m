//
//  NSString+ContainsString.m
//
//  Created by konstantin on 16/05/2012.
//  Copyright (c) 2012 KTTSoft. All rights reserved.
//

#import "NSString+ContainsString.h"

@implementation NSString (ContainsString)




//////////////////////////////////////////////////////////////////////////////////////////////
// check whether string contains another string
//

-(BOOL) containsSubrString:(NSString*)patternStr {
    
    if (self.length == 0)
        return FALSE;
    
    if (patternStr.length == 0)
        return TRUE;
    
    NSRange range = [self rangeOfString:patternStr options:NSCaseInsensitiveSearch];
    return range.location != NSNotFound;
}

@end
