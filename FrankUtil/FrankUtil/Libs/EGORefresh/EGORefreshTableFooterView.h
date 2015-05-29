//
//  EGORefreshTableFooterView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPullingUp = 0,
	EGOOPullRefreshNormalState,
	EGOOPullRefreshLoadingState,	
} EGOPullRefreshFooterState;

@protocol EGORefreshTableFooterDelegate;
@interface EGORefreshTableFooterView : UIView {
	
	id<EGORefreshTableFooterDelegate> _delegate;
	EGOPullRefreshFooterState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic) id <EGORefreshTableFooterDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView animated:(BOOL)animated;

@end
@protocol EGORefreshTableFooterDelegate<NSObject>
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view;
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view;
@optional
- (NSDate*)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView*)view;
@end
