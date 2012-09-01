//
//  NSURL+AppDotNet.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "NSURL+AppDotNet.h"

#define kMyToken @"AQAAAAAAAJvMx7ls3vwW8GVkJB-hd8N0WYXFhuQLBVwsLjdayywuum-qP-6xcYvD5j3_kI_Td90P-XdH2mkBt8EatIVWbhMfuA"

@implementation NSURL (AppDotNet)

+ (NSURL *)appDotNetURL:(NSString *)resourcePath {
    NSString *absolutePath = [NSString stringWithFormat:@"https://alpha-api.app.net/%@?access_token=%@", resourcePath, kMyToken];
    //absolutePath = [absolutePath stringByReplacingOccurrencesOfString:@"CURRENT_USER" withString:@"12"];
    return [NSURL URLWithString:absolutePath];
}

+ (NSURL *)appDotNetMainFeedURL {
    return [NSURL appDotNetURL:@"stream/0/posts/stream"];
}

@end
