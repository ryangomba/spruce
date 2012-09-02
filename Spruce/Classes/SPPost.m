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
#import "SPLinkedEntity.h"

@implementation SPPost

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setPk:[dictionary objectOrNilForKey:@"id"]];
        [self setThreadPK:[dictionary objectOrNilForKey:@"thread_id"]];
        [self setText:[dictionary objectOrNilForKey:@"text"]];
        [self setNumReplies:[[dictionary objectOrNilForKey:@"num_replies"] intValue]];
        
        NSDictionary *entitiesDict = [dictionary objectOrNilForKey:@"entities"];
        if (entitiesDict) {
            NSArray *tagLinkDicts = [entitiesDict objectOrNilForKey:@"hashtags"];
            [self setTagLinks:[NSMutableArray arrayWithCapacity:[tagLinkDicts count]]];
            for (NSDictionary *dictionary in tagLinkDicts) {
                SPLinkedEntityTag *link = [[SPLinkedEntityTag alloc] initWithDictionary:dictionary];
                [(NSMutableArray *)self.tagLinks addObject:link];
            }
            NSArray *webLinkDicts = [entitiesDict objectOrNilForKey:@"links"];
            [self setWebLinks:[NSMutableArray arrayWithCapacity:[webLinkDicts count]]];
            for (NSDictionary *dictionary in webLinkDicts) {
                 SPLinkedEntityWeb *link = [[SPLinkedEntityWeb alloc] initWithDictionary:dictionary];
                 [(NSMutableArray *)self.webLinks addObject:link];
            }
            NSArray *userLinkDicts = [entitiesDict objectOrNilForKey:@"mentions"];
            [self setUserLinks:[NSMutableArray arrayWithCapacity:[userLinkDicts count]]];
            for (NSDictionary *dictionary in userLinkDicts) {
                SPLinkedEntityUser *link = [[SPLinkedEntityUser alloc] initWithDictionary:dictionary];
                [(NSMutableArray *)self.userLinks addObject:link];
            }
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

- (NSMutableAttributedString *)attributedText {
    // TODO check if already produced
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    SPAttributedStringCreator *creator = [[SPAttributedStringCreator alloc] init];
    
    [creator setString:[NSString stringWithFormat:@"%@\u2029", self.user.name]];
    [creator makeLarge];
    [attributedString appendAttributedString:creator.attributedString];
    
    [creator setString:self.text];
    for (SPLinkedEntity *tagLink in self.tagLinks) {
        [creator attachLinkedEntity:tagLink];
    }
    for (SPLinkedEntity *webLink in self.webLinks) {
        [creator attachLinkedEntity:webLink];
    }
    for (SPLinkedEntity *userLink in self.userLinks) {
        [creator attachLinkedEntity:userLink];
    }
    [attributedString appendAttributedString:creator.attributedString];
    
    return attributedString;
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
