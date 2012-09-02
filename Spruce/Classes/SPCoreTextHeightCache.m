//
//  SPCoreTextHeightCache.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPCoreTextHeightCache.h"

#define kSPCoreTextHeightCacheSize 100

@implementation SPCoreTextHeightCache

- (id)init {
    if (self = [super init]) {
        [self setCountLimit:kSPCoreTextHeightCacheSize];
    }
    return self;
}

+ (SPCoreTextHeightCache *)sharedCache {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[SPCoreTextHeightCache alloc] init];
    });
}

@end
