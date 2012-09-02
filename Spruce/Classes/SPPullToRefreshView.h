//
//  SPPullToRefreshView.h
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,
} EGOPullRefreshState;

@protocol SPPullToRefreshViewDelegate;

@interface SPPullToRefreshView : UIView

@property(nonatomic, weak) id<SPPullToRefreshViewDelegate> delegate;

- (id)initWithDelegate:(id<SPPullToRefreshViewDelegate>)delegate;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)dataSourceDidRefresh:(UIScrollView *)scrollView;

@end

@protocol SPPullToRefreshViewDelegate <NSObject>

- (void)pullToRefreshViewDidTriggerRefresh:(SPPullToRefreshView *)view;
- (BOOL)networkDataSourceIsLoading:(SPPullToRefreshView *)view;

@end
