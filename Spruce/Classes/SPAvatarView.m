//
//  SPAvatarView.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPAvatarView.h"

#import "SPUser.h"
#import "SPImageView.h"

@implementation SPAvatarView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setAvatarImageView:[[SPImageView alloc] initWithFrame:self.bounds]];
        [self.avatarImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self addSubview:self.avatarImageView];
        
        [self setAvatarButton:[[UIButton alloc] initWithFrame:self.bounds]];
        [self.avatarButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        UIImage *frameImage = [[UIImage imageNamed:@"avatar-overlay.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
        [self.avatarButton setBackgroundImage:frameImage forState:UIControlStateNormal];
        [self.avatarButton setAdjustsImageWhenHighlighted:NO];
        [self addSubview:self.avatarButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame user:(SPUser *)user {
    if (self = [self initWithFrame:frame]) {
        [self setUser:user];
    }
    return self;
}

- (void)setUser:(SPUser *)user {
    self.user = user;
    
    [self.avatarImageView setImageURL:user.avatarURL];
}

- (id)initWithUser:(SPUser *)user {
    return [self initWithFrame:CGRectMake(0, 0, kSPAvatarViewDefaultAvatarSize, kSPAvatarViewDefaultAvatarSize) user:user];
}

- (void)setTarget:(id)target action:(SEL)action {
    [self.avatarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
