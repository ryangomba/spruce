//
//  SPFeedPostTableViewCell.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@class SPPost;
@class SPAvatarView;
@class SPCoreTextView;

@interface SPFeedPostTableViewCell : UITableViewCell {
    SPAvatarView *_avatarView;
    SPCoreTextView *_textView;
}

@property (nonatomic, strong) SPPost *post;

+ (CGFloat)heightWithPost:(SPPost *)post;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
