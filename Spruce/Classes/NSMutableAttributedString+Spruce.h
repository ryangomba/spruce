//
//  NSMutableAttributedString+Spruce.h
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@class SPLinkedEntity;

@interface NSMutableAttributedString (Spruce)

- (void)setDefaultParagraphSettings;

- (void)attachLinkedEntity:(SPLinkedEntity *)linkedEntity;

@end
