

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];//显示时间的区域背景颜色
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
#if !__has_feature(objc_arc)
		[label release];
#endif
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
#if !__has_feature(objc_arc)
		[label release];
#endif
		
		CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(25.0f, frame.size.height - 46.0f, 45.0f, 37.0f);
        
        
		layer.contentsGravity = kCAGravityResizeAspect;
        //下拉刷新时候的箭头图片
        layer.contents = (id)[UIImage imageNamed:@"pao1.png"].CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
        if (!pathView) {
            pathView =[[GifView alloc] initWithFrame:CGRectMake(25.0f, frame.size.height - 46.0f, 45.0f, 37.0f) filePath:[[NSBundle mainBundle] pathForResource:@"pullDownFresh" ofType:@"gif"]];
            [self  addSubview:pathView];
            [pathView setAlpha:0];
#if !__has_feature(objc_arc)
            [pathView release];
#endif
        }
       
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"上次刷新: ", @""), [formatter stringFromDate:date]];
#if !__has_feature(objc_arc)
        [formatter release];
#endif
        
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"KEGORefreshTableView_LastRefresh"];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"松开手开始刷新...", @"");
            [pathView setAlpha:0];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
            _arrowImage.contents = (id)[UIImage imageNamed:@"pao1.png"].CGImage;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			_statusLabel.text = NSLocalizedString(@"下拉即可刷新...", @"");
            [pathView setAlpha:0];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
            _arrowImage.contents = (id)[UIImage imageNamed:@"pao2.png"].CGImage;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
		case EGOOPullRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"正在载入...", @"");
            [pathView setAlpha:1];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
            [self refreshLastUpdatedDate];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}

	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        //scrollView管理的为 下拉刷新整个表中的区域
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        //scrollView.backgroundColor = [UIColor redColor];
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(egoRefreshTableHeaderViewAnimationDidStoped)];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
    
}

- (void)egoRefreshTableHeaderViewAnimationDidStoped {
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderAnimationDidFinished)]) {
        [_delegate egoRefreshTableHeaderAnimationDidFinished];
    }
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
    pathView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


@end
