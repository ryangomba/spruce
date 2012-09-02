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

- (id)linkInfo {
    return nil; // subclasses should implement
}

@end


#pragma mark -
#pragma mark Web Link

@implementation SPLinkedEntityWeb

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        [self setDisplayString:[dictionary objectOrNilForKey:@"text"]];
        NSString *urlString = [dictionary objectOrNilForKey:@"url"];
        if (urlString) {
            [self setUrl:[NSURL URLWithString:urlString]];
        }
        [self setLinkType:SPLinkTypeWeb];
    }
    return self;
}

- (id)linkInfo {
    return self.url;
}

@end


#pragma mark -
#pragma mark Tag Link

@implementation SPLinkedEntityTag

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        [self setDisplayString:[dictionary objectOrNilForKey:@"name"]];
        [self setLinkType:SPLinkTypeTag];
    }
    return self;
}

- (id)linkInfo {
    return self.displayString;
}

@end


#pragma mark -
#pragma mark Web Link

@implementation SPLinkedEntityUser

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        [self setDisplayString:[dictionary objectOrNilForKey:@"name"]];
        [self setUserPK:[dictionary objectOrNilForKey:@"id"]];
        [self setLinkType:SPLinkTypeUser];
    }
    return self;
}

- (id)linkInfo {
    return self.userPK;
}

@end
