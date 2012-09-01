//
//  SPFeedPostTableViewCell.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@class SPPost;
@class SPImageView;

@interface SPFeedPostTableViewCell : UITableViewCell {
    SPImageView *_avatarView;
}

@property (nonatomic, strong) SPPost *post;

+ (CGFloat)heightWithPost:(SPPost *)post;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
