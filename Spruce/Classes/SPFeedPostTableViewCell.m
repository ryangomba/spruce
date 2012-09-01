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
#import "SPImageView.h"
#import "SPAttributedStringCreator.h"
#import "UIView+AttributedString.h"

#define kTopPadding 15
#define kHorizontalPadding 10
#define kImageSize 50
#define kTextWith 240

@implementation SPFeedPostTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];
        
        _avatarView = [[SPImageView alloc] initWithFrame:CGRectMake(kHorizontalPadding, kTopPadding, kImageSize, kImageSize)];
        [self addSubview:_avatarView];
    }
    return self;
}

+ (CGFloat)heightWithPost:(SPPost *)post {
    CGFloat textHeight = [SPAttributedStringCreator heightForAttributedString:post.attributedText width:kTextWith];
    return MAX(textHeight, kImageSize) + 2 * kTopPadding;
}

- (void)setPost:(SPPost *)post {
    _post = post;
    
    [_avatarView setImageURL:post.user.avatarURL];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGPoint textOrigin = CGPointMake(2 * kHorizontalPadding + kImageSize, kTopPadding - 2.0f);
    [self drawAttributedString:self.post.attributedText atPoint:textOrigin width:kTextWith];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGFloat lineLength = self.bounds.size.width;
    CGFloat lineY = self.bounds.size.height - 1.0f;
    
    [HEX_COLOR(0xaaaaaa) set];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, lineY);
    CGContextAddLineToPoint(context, lineLength, lineY);
    CGContextStrokePath(context);
    
    lineY += 0.5f;
    
    [HEX_COLOR(0xffffff) set];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, lineY);
    CGContextAddLineToPoint(context, lineLength, lineY);
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
    //
}

@end
