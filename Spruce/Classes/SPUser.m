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


#pragma mark -
#pragma mark NSObject

- (id)initWithPK:(NSString *)pk {
    if (self = [super init]) {
        [self setPk:pk];
    }
    return self;
}

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
            CGFloat coverHeight = [[coverDict objectOrNilForKey:@"height"] intValue];
            CGFloat coverWidth = [[coverDict objectOrNilForKey:@"width"] intValue];
            if (coverHeight && coverWidth) {
                [self setCoverURL:[NSURL URLWithString:[coverDict objectOrNilForKey:@"url"]]];
                [self setCoverAspectRatio:coverWidth / coverHeight];
            }
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


#pragma mark -
#pragma mark Equality Tests

- (NSUInteger)hash {
    return [self.pk hash];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:self.class]) {
        return [self.pk isEqual:[object pk]];
    }
    return NO;
}


@end
