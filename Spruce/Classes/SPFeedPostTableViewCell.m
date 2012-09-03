//
//  SPFeedPostTableViewCell.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPFeedPostTableViewCell.h"

#import "SPUser.h"
#import "SPPost.h"
#import "SPAvatarView.h"
#import "SPCoreTextView.h"
#import "SPUserViewController.h"
#import "SPAppDelegate.h"

#define kTextWith 240

@interface SPFeedPostTableViewCell ()

@property (nonatomic, strong) SPAvatarView *avatarView;
@property (nonatomic, strong) SPCoreTextView *textView;

@end


@implementation SPFeedPostTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];
        
        self.avatarView = [[SPAvatarView alloc] initWithUser:nil];
        [self.avatarView setOrigin:CGPointMake(kSPDefaultPadding, kSPDefaultPadding)];
        [self.avatarView setTarget:self action:@selector(avatarTapped)];
        [self addSubview:self.avatarView];
        
        CGPoint textOrigin = CGPointMake(2 * kSPDefaultPadding + kSPAvatarViewDefaultAvatarSize, kSPDefaultPadding - 1.0f);
        self.textView = [[SPCoreTextView alloc] initWithOrigin:textOrigin width:kTextWith];
        [self.textView setShadowColor:kSPHighlightColor];
        [self.textView setShadowOffset:1.0f];
        [self addSubview:self.textView];
    }
    return self;
}

+ (CGFloat)heightWithPost:(SPPost *)post {
    CGFloat textHeight = [SPCoreTextView heightWithAttributedString:post.attributedText width:kTextWith];
    return MAX(textHeight, kSPAvatarViewDefaultAvatarSize) + 2 * kSPDefaultPadding;
}

- (void)setPost:(SPPost *)post {
    _post = post;
    
    [self.avatarView setUser:post.user];
    [self.textView setAttributedString:post.attributedText];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.5f);
    CGFloat lineLength = self.bounds.size.width;
    CGFloat lineY = self.bounds.size.height - 1.0f;
    
    [kSPLineColor set];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, lineY);
    CGContextAddLineToPoint(context, lineLength, lineY);
    CGContextStrokePath(context);
    
    lineY += 0.5f;
    
    [[UIColor whiteColor] set];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, lineY);
    CGContextAddLineToPoint(context, lineLength, lineY);
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
    //
}

- (void)avatarTapped {
    SPUserViewController *userVC = [[SPUserViewController alloc] initWithUser:self.post.user];
    SPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootNavigationController pushViewController:userVC animated:YES];
}

@end
