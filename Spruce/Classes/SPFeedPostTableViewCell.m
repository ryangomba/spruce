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
#import "SPAttributedStringDrawer.h"

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
        
        _attributedStringDrawer = [self.class attributedStringDrawer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

+ (SPAttributedStringDrawer *)attributedStringDrawer {
    CGPoint textOrigin = CGPointMake(2 * kHorizontalPadding + kImageSize, kTopPadding - 2.0f);
    SPAttributedStringDrawer *drawer = [[SPAttributedStringDrawer alloc] initWithPosition:textOrigin width:kTextWith];
    [drawer setShadowColor:HEX_COLOR(0xf5f5f5)];
    [drawer setShadowOffset:1.0f];
    return drawer;
}

+ (CGFloat)heightWithPost:(SPPost *)post {
    SPAttributedStringDrawer *drawer = [SPFeedPostTableViewCell attributedStringDrawer];
    [drawer setAttributedString:post.attributedText];
    CGFloat textHeight = [drawer drawnHeight];
    return MAX(textHeight, kImageSize) + 2 * kTopPadding;
}

- (void)setPost:(SPPost *)post {
    _post = post;
    
    [_avatarView setImageURL:post.user.avatarURL];
    [_attributedStringDrawer setAttributedString:post.attributedText];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer {
    _tapped = YES;
    _tapPosition = [recognizer locationInView:self];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [_attributedStringDrawer drawInView:self];
    if (_tapped) {
        NSInteger tapIndex = [_attributedStringDrawer indexForTapAtPoint:_tapPosition inView:self];
        NSLog(@"%d", tapIndex);
        _tapped = NO;
    }
    
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
