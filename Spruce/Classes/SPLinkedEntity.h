//
//  SPLinkedEntity.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

typedef enum {
    SPLinkTypeWeb = 1,
    SPLinkTypeTag,
    SPLinkTypeUser,
} SPLinkType;


#pragma mark -
#pragma mark Abstract Entity

@interface SPLinkedEntity : NSObject

@property (nonatomic, assign) SPLinkType linkType;
@property (nonatomic, assign) NSRange textRange;
@property (nonatomic, copy) NSString *displayString;
@property (nonatomic, readonly) id linkInfo;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


#pragma mark -
#pragma mark Specific Entities

@interface SPLinkedEntityWeb : SPLinkedEntity
@property (nonatomic, strong) NSURL *url;
@end

@interface SPLinkedEntityTag : SPLinkedEntity
@end

@interface SPLinkedEntityUser : SPLinkedEntity
@property (nonatomic, copy) NSString *userPK;
@end
