//
//  SPAttributedStringDrawer.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface SPAttributedStringDrawer : NSObject {
    BOOL _heightIsValid;
}

@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGFloat drawnHeight;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat shadowOffset;
@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic, readonly) CGRect frame;

- (id)initWithPosition:(CGPoint)position width:(CGFloat)width;

- (void)drawInView:(UIView *)view;

- (NSInteger)indexForTapAtPoint:(CGPoint)point inView:(UIView *)view;

@end
