//
//  NSURL+Spruce.h
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface NSURL (Spruce)

+ (NSURL *)spruceBaseURL;

+ (NSURL *)spruceUserURLForPK:(NSString *)userPK;
+ (NSURL *)spruceTagURLForTagName:(NSString *)tagName;

+ (SPViewController *)viewControllerForURL:(NSURL *)url;

@end
