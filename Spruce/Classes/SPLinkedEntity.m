//
//  SPLinkedEntity.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPLinkedEntity.h"

#import "NSDictionary+Safe.h"


#pragma mark -
#pragma mark Abstract Entity

@implementation SPLinkedEntity

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSInteger location = [[dictionary objectOrNilForKey:@"pos"] intValue];
        NSInteger length = [[dictionary objectOrNilForKey:@"len"] intValue];
        [self setTextRange:NSMakeRange(location, length)];
    }
    return self;
}

@end


#pragma mark -
#pragma mark Web Link

@implementation SPLinkedEntityWeb

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        [self setLinkType:SPLinkTypeWeb];
        [self setDisplayString:[dictionary objectOrNilForKey:@"text"]];
        [self setUrl:[NSURL URLWithString:[dictionary objectOrNilForKey:@"url"]]];
    }
    return self;
}

@end


#pragma mark -
#pragma mark Tag Link

@implementation SPLinkedEntityTag

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        [self setLinkType:SPLinkTypeTag];
        [self setDisplayString:[dictionary objectOrNilForKey:@"name"]];
        NSString *urlString = [NSString stringWithFormat:@"spruce://tag/%@", [self.displayString lowercaseString]];
        [self setUrl:[NSURL URLWithString:urlString]];
    }
    return self;
}

@end


#pragma mark -
#pragma mark Web Link

@implementation SPLinkedEntityUser

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        [self setLinkType:SPLinkTypeUser];
        [self setDisplayString:[dictionary objectOrNilForKey:@"name"]];
        NSString *userPK = [dictionary objectOrNilForKey:@"id"];
        NSString *urlString = [NSString stringWithFormat:@"spruce://user/%@", userPK];
        [self setUrl:[NSURL URLWithString:urlString]];
    }
    return self;
}

@end
