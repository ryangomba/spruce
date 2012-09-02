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
#import "SPCoreTextView.h"

#define kTopPadding 10
#define kHorizontalPadding 10
#define kImageSize 50
#define kTextWith 240

@implementation SPFeedPostTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];
        
        CGRect avatarRect = CGRectMake(kHorizontalPadding, kTopPadding, kImageSize, kImageSize);
        _avatarView = [[SPImageView alloc] initWithFrame:avatarRect overlay:YES];
        [self addSubview:_avatarView];
        
        CGPoint textOrigin = CGPointMake(2 * kHorizontalPadding + kImageSize, kTopPadding - 1.0f);
        _textView = [[SPCoreTextView alloc] initWithOrigin:textOrigin width:kTextWith];
        [_textView setShadowColor:HEX_COLOR(0xf5f5f5)];
        [_textView setShadowOffset:1.0f];
        [self addSubview:_textView];
    }
    return self;
}

+ (CGFloat)heightWithPost:(SPPost *)post {
    CGFloat textHeight = [SPCoreTextView heightWithAttributedString:post.attributedText width:kTextWith];
    return MAX(textHeight, kImageSize) + 2 * kTopPadding;
}

- (void)setPost:(SPPost *)post {
    _post = post;
    
    [_avatarView setImageURL:post.user.avatarURL];
    [_textView setAttributedString:post.attributedText];
    
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
