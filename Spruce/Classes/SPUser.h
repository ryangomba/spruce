//
//  SPUser.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface SPUser : NSObject

@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSDate *joinedAt;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSURL *coverURL;
@property (nonatomic, assign) CGFloat coverAspectRatio;

@property (nonatomic, assign) NSInteger numFollowers;
@property (nonatomic, assign) NSInteger numFollowing;
@property (nonatomic, assign) NSInteger numPosts;

@property (nonatomic, assign) BOOL isFollowingMe;
@property (nonatomic, assign) BOOL isFollowedByMe;
@property (nonatomic, assign) BOOL isMuted;

- (id)initWithPK:(NSString *)pk;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
