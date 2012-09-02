//
//  SPDecodedImageCache.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPDecodedImageCache.h"

#define kSPDecodedImageCacheSize 100

@implementation SPDecodedImageCache

- (id)init {
    if (self = [super init]) {
        // TODO weights are better
        [self setCountLimit:kSPDecodedImageCacheSize];
    }
    return self;
}

+ (SPDecodedImageCache *)sharedCache {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[SPDecodedImageCache alloc] init];
    });
}

@end
