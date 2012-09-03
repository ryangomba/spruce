//
//  SPAttributedStringCreator.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#define kSPAttributedStringLinkType @"SPLinkType"
#define kSPAttributedStringLinkInfo @"SPLinkInfo"

@class SPLinkedEntity;

@interface SPAttributedStringCreator : NSObject

@property (nonatomic, strong) NSMutableAttributedString *attributedString;

- (void)setString:(NSString *)string;

- (void)makeLarge;
- (void)attachLinkedEntity:(SPLinkedEntity *)linkedEntity;

- (void)highlight:(BOOL)highlight linkAtIndex:(NSInteger)index;

@end
