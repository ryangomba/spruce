//
//  SPImageLoadQueue.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPImageLoadQueue.h"

@implementation SPImageLoadQueue

+ (id)sharedQueue {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[SPImageLoadQueue alloc] init];
    });
}

@end
