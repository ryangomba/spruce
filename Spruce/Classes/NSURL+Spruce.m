//
//  NSURL+Spruce.m
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "NSURL+Spruce.h"

#import "SPUser.h"
//#import "SPTag"
#import "SPWebViewController.h"
#import "SPUserViewController.h"
//#import "SPTagViewController.h"

@implementation NSURL (Spruce)

+ (NSURL *)spruceBaseURL {
    return [NSURL URLWithString:@"spruce://"];
}

+ (NSURL *)spruceUserURLForPK:(NSString *)userPK {
    NSString *relativeString = [NSString stringWithFormat:@"user/%@", userPK];
    return [NSURL URLWithString:relativeString relativeToURL:[NSURL spruceBaseURL]];
}

+ (NSURL *)spruceTagURLForTagName:(NSString *)tagName {
    NSString *relativeString = [NSString stringWithFormat:@"tag/%@", tagName];
    return [NSURL URLWithString:relativeString relativeToURL:[NSURL spruceBaseURL]];
}

+ (SPViewController *)viewControllerForURL:(NSURL *)url {
    if (![url.baseURL isEqual:[NSURL spruceBaseURL]]) {
        SPWebViewController *webVC = [[SPWebViewController alloc] initWithURL:url];
        return webVC;
    }
    NSString *relativeString = url.relativeString;
    NSArray *urlComponents = [relativeString componentsSeparatedByString:@"/"];
    if ([urlComponents count] < 2) {
        return nil;
    }
    NSString *resource = [urlComponents objectAtIndex:0];
    NSString *key = [urlComponents objectAtIndex:1];
    if ([resource isEqual:@"user"]) {
        SPUser *user = [[SPUser alloc] initWithPK:key];
        SPUserViewController *userVC = [[SPUserViewController alloc] initWithUser:user];
        return userVC;
    }
//    if ([resource isEqual:@"tag"]) {
//        SPTag *tag = [[SPTag alloc] initWithName:key];
//        SPTagViewController *tagVC = [[SPTagViewController alloc] initWithTag:tag];
//        return tagVC;
//    }
    return nil;
}

@end
