//
//  NSDate+AppDotNet.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "NSDate+AppDotNet.h"

@implementation NSDate (AppDotNet)

+ (NSDate *)dateFromAppDotNetString:(NSString *)appDotNetString {
    if (appDotNetString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-ddThh:mm:ssZ"];
        return [dateFormatter dateFromString:appDotNetString];
    }
    return nil;
}

@end
