//
//  SPPost.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@class SPUser;

@interface SPPost : NSObject

@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *threadPK;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) NSInteger numReplies;

@property (nonatomic, strong) NSArray *webLinks;
@property (nonatomic, strong) NSArray *tagLinks;
@property (nonatomic, strong) NSArray *userLinks;

@property (nonatomic, strong) NSString *sourceName;
@property (nonatomic, strong) NSURL *sourceURL;

@property (nonatomic, strong) SPUser *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableAttributedString *)attributedText;

@end
