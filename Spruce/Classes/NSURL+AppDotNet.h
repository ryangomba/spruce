//
//  NSURL+AppDotNet.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface NSURL (AppDotNet)

+ (NSURL *)appDotNetURL:(NSString *)resourcePath;

+ (NSURL *)appDotNetMainFeedURL;

@end
