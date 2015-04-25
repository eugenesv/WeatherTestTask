//
//  UIView+MakeFromXib.m
//
//  Created by Konstantin on 29/08/2014.
//  Copyright (c) 2014 kttsoft. All rights reserved.
//

#import "UIView+MakeFromXib.h"

@implementation UIView (MakeFromXib)

+ (instancetype)makeFromXibWithFileOwner:(id)owner {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:owner options:nil];
    if (nibs.count)
        return nibs[0];
    
    return nil;
}

@end
