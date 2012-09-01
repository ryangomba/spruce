//
//  SPUser.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPUser.h"

#import "NSDictionary+Safe.h"
#import "NSDate+AppDotNet.h"

@implementation SPUser

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setPk:[dictionary objectOrNilForKey:@"id"]];
        [self setName:[dictionary objectOrNilForKey:@"name"]];
        [self setUsername:[dictionary objectOrNilForKey:@"username"]];
        
        NSString *joinedAtString = [dictionary objectOrNilForKey:@"created_at"];
        [self setJoinedAt:[NSDate dateFromAppDotNetString:joinedAtString]];
        
        NSDictionary *avatarDict = [dictionary objectOrNilForKey:@"avatar_image"];
        if (avatarDict) {
            [self setAvatarURL:[NSURL URLWithString:[avatarDict objectOrNilForKey:@"url"]]];
        }
        
        NSDictionary *coverDict = [dictionary objectOrNilForKey:@"cover_image"];
        if (coverDict) {
            [self setCoverURL:[NSURL URLWithString:[coverDict objectOrNilForKey:@"url"]]];
        }
        
        NSDictionary *countsDict = [dictionary objectOrNilForKey:@"counts"];
        if (countsDict) {
            [self setNumFollowers:[[countsDict objectOrNilForKey:@"followers"] intValue]];
            [self setNumFollowing:[[countsDict objectOrNilForKey:@"following"] intValue]];
            [self setNumPosts:[[countsDict objectOrNilForKey:@"posts"] intValue]];
        }
        
        [self setIsFollowingMe:[[dictionary objectOrNilForKey:@"follows_you"] boolValue]];
        [self setIsFollowedByMe:[[dictionary objectOrNilForKey:@"you_follow"] boolValue]];
        [self setIsMuted:[[dictionary objectOrNilForKey:@"you_muted"] boolValue]];
    }
    return self;
}

@end
