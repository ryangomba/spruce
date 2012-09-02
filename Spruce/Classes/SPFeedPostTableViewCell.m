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

#define kTopPadding 15
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
        
        _textView = [self.class makeCoreTextView];
        [self addSubview:_textView];
    }
    return self;
}

+ (SPCoreTextView *)makeCoreTextView {
    CGPoint textOrigin = CGPointMake(2 * kHorizontalPadding + kImageSize, kTopPadding - 2.0f);
    SPCoreTextView *textView = [[SPCoreTextView alloc] initWithOrigin:textOrigin width:kTextWith];
    [textView setShadowColor:HEX_COLOR(0xf5f5f5)];
    [textView setShadowOffset:1.0f];
    return textView;
}

+ (CGFloat)heightWithPost:(SPPost *)post {
    SPCoreTextView *textView = [SPFeedPostTableViewCell makeCoreTextView];
    [textView setAttributedString:post.attributedText];
    return MAX(textView.height, kImageSize) + 2 * kTopPadding;
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
