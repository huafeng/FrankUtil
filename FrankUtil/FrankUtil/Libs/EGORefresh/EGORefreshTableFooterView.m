//
//  EGORefreshTableFooterView.m
//  Demo
//
//


#define  RefreshViewHight 65.0f

#import "EGORefreshTableFooterView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableFooterView (Private)
- (void)setState:(EGOPullRefreshFooterState)aState;
@end

@implementation EGORefreshTableFooterView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
		
        [self setUserInteractionEnabled:YES];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 30.0f, self.frame.size.width, 20.0f)];
		//label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
#if !__has_feature(objc_arc)
        [label release];
#endif
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 48.0f, self.frame.size.width, 20.0f)];
		//label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:17];//13
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
#if !__has_feature(objc_arc)
        [label release];
#endif
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, RefreshViewHight - 48.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
#if !__has_feature(objc_arc)
        [view release];
#endif
		
		[self setState:EGOOPullRefreshNormalState];
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

}

- (void)setState:(EGOPullRefreshFooterState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPullingUp:
            _statusLabel.text = NSLocalizedString(@"加载更多", @"");
			
			break;
		case EGOOPullRefreshNormalState:
			if (_state == EGOOPullRefreshPullingUp) {
			}
			
            _statusLabel.text = NSLocalizedString(@"加载更多", @"");
            
			[_activityView stopAnimating];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoadingState:
            _statusLabel.text = NSLocalizedString(@"加载更多", @"");
			[_activityView startAnimating];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoadingState) {
		
		scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPullingUp && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormalState];
		} else if (_state == EGOOPullRefreshNormalState && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading) {
			[self setState:EGOOPullRefreshPullingUp];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableFooterDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableFooterDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableFooterDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoadingState];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[self setState:EGOOPullRefreshNormalState];
    


}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView animated:(BOOL)animated {
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [UIView commitAnimations];
        [self setState:EGOOPullRefreshNormalState];
    } else {
        [self setState:EGOOPullRefreshNormalState];
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    }
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
//	_arrowImage = nil;
	_lastUpdatedLabel = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


@end
