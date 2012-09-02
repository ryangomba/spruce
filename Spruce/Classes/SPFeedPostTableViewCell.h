//
//  SPFeedPostTableViewCell.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@class SPPost;
@class SPImageView;
@class SPAttributedStringDrawer;

@interface SPFeedPostTableViewCell : UITableViewCell {
    SPImageView *_avatarView;
    SPAttributedStringDrawer *_attributedStringDrawer;
}

@property (nonatomic, strong) SPPost *post;

+ (CGFloat)heightWithPost:(SPPost *)post;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
