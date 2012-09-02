//
//  SPAvatarView.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#define kSPAvatarViewDefaultAvatarSize 50

@class SPUser;
@class SPImageView;

@interface SPAvatarView : UIView

@property (nonatomic, strong) SPUser *user;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) SPImageView *avatarImageView;

- (id)initWithUser:(SPUser *)user;
- (id)initWithFrame:(CGRect)frame user:(SPUser *)user;

- (void)setTarget:(id)target action:(SEL)action;

@end
