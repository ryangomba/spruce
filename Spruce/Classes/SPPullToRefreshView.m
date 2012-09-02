//
//  SPPullToRefreshView.m
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPPullToRefreshView.h"

#import <QuartzCore/QuartzCore.h>

#define kHeight 98
#define kArrowFlipAnimationDuration 0.18f

@interface SPPullToRefreshView ()

@property (nonatomic, strong) UILabel *lastUpdatedLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CALayer *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, assign) EGOPullRefreshState state;

@end


@implementation SPPullToRefreshView

#pragma mark -
#pragma mark NSObject

- (id)initWithDelegate:(id<SPPullToRefreshViewDelegate>)delegate  {
    if((self = [super initWithFrame:CGRectMake(0, -kHeight, kSPDeviceWidth, kHeight)])) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = kSPDefaultTextColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = kSPDefaultTextColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, self.frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@""].CGImage;
		
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
        #endif
        
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, self.frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
        
        [self setDelegate:delegate];
		[self setState:EGOOPullRefreshNormal];
    }
    return self;
}


#pragma mark -
#pragma mark Private Methods

- (void)refreshLastUpdatedDate {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *lastUpdatedString = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
    [self.lastUpdatedLabel setText:NSLocalizedString(lastUpdatedString, nil)];
}

- (void)setState:(EGOPullRefreshState)state {
	switch (state) {
		case EGOOPullRefreshPulling:
			_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:kArrowFlipAnimationDuration];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
            
		case EGOOPullRefreshNormal:
			if (self.state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:kArrowFlipAnimationDuration];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
			[self.activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			[self refreshLastUpdatedDate];
			break;
            
		case EGOOPullRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[self.activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			break;
            
		default:
			break;
	}
	_state = state;
}


#pragma mark -
#pragma mark UIScrollView Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.state == EGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        
	} else if (scrollView.isDragging) {
		BOOL loading = NO;
		if ([self.delegate respondsToSelector:@selector(networkDataSourceIsLoading:)]) {
			loading = [self.delegate networkDataSourceIsLoading:self];
		}
		if (self.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (self.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL loading = NO;
	if ([self.delegate respondsToSelector:@selector(networkDataSourceIsLoading:)]) {
		loading = [self.delegate networkDataSourceIsLoading:self];
	}
	if (scrollView.contentOffset.y <= - 65.0f && !loading) {
		if ([self.delegate respondsToSelector:@selector(pullToRefreshViewDidTriggerRefresh:)]) {
			[self.delegate pullToRefreshViewDidTriggerRefresh:self];
		}
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)dataSourceDidRefresh:(UIScrollView *)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    
	[self setState:EGOOPullRefreshNormal];
}


@end
