//
//  SPPost.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPPost.h"

#import "SPUser.h"
#import "NSDictionary+Safe.h"
#import "NSDate+AppDotNet.h"
#import <CoreText/CoreText.h>
#import "SPAttributedStringCreator.h"

@implementation SPPost

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setPk:[dictionary objectOrNilForKey:@"id"]];
        [self setThreadPK:[dictionary objectOrNilForKey:@"thread_id"]];
        [self setText:[dictionary objectOrNilForKey:@"text"]];
        [self setNumReplies:[[dictionary objectOrNilForKey:@"num_replies"] intValue]];
        
        NSDictionary *entitiesDict = [dictionary objectOrNilForKey:@"entities"];
        if (entitiesDict) {
            [self setHashtagInfos:[entitiesDict objectOrNilForKey:@"hashtags"]];
            [self setLinkInfos:[entitiesDict objectOrNilForKey:@"links"]];
            [self setMentionInfos:[entitiesDict objectOrNilForKey:@"mentions"]];
        }
        
        NSDictionary *sourceDict = [dictionary objectOrNilForKey:@"source"];
        if (sourceDict) {
            [self setSourceName:[sourceDict objectOrNilForKey:@"name"]];
            [self setSourceURL:[NSURL URLWithString:[sourceDict objectOrNilForKey:@"link"]]];
        }
        
        NSString *createdAtString = [dictionary objectOrNilForKey:@"created_at"];
        [self setTimestamp:[NSDate dateFromAppDotNetString:createdAtString]];
        
        NSDictionary *userDict = [dictionary objectOrNilForKey:@"user"];
        if (userDict) {
            [self setUser:[[SPUser alloc] initWithDictionary:userDict]];
        }
    }
    return self;
}


// ATTR

- (NSRange)rangeForInfo:(NSDictionary *)info {
    NSInteger location = [[info objectOrNilForKey:@"pos"] intValue];
    NSInteger length = [[info objectOrNilForKey:@"len"] intValue];
    return NSMakeRange(location, length);
}

- (NSMutableAttributedString *)attributedText {
    // check if already produced
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    SPAttributedStringCreator *creator = [[SPAttributedStringCreator alloc] init];
    
    [creator setString:[NSString stringWithFormat:@"%@\u2029", self.user.name]];
    [creator makeLarge];
    [attributedString appendAttributedString:creator.attributedString];
    
    [creator setString:self.text];
    for (NSDictionary *hashtagInfo in self.hashtagInfos) {
        [creator makeTag:[self rangeForInfo:hashtagInfo]];
    }
    for (NSDictionary *hashtagInfo in self.linkInfos) {
        [creator makeLink:[self rangeForInfo:hashtagInfo]];
    }
    for (NSDictionary *hashtagInfo in self.mentionInfos) {
        NSRange range = [self rangeForInfo:hashtagInfo];
        [creator makeLink:range];
        [creator makeBold:range];
    }
    [attributedString appendAttributedString:creator.attributedString];
    
    return attributedString;
}

@end
