//
//  XLCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import "XLCycleScrollView.h"
#import "SMPageControl.h"

#define SCROLL_TIMEINTERVAL 3.5
#define TAG_LOADING_VIEW 2222

@interface XLCycleScrollView ()

@property (nonatomic, assign) bool isAutoCycling;

@end

@implementation XLCycleScrollView

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    _delegate = nil;
    _datasource = nil;
    _scrollView.delegate = nil;
    _scrollView = nil;
    _pageControl = nil;
    _curViews = nil;
    [_scrollView removeGestureRecognizer:_singleTap];
    _singleTap = nil;
}

- (id)initWithFrame:(CGRect)frame autoCycle:(BOOL)autoCycle
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
//        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 16;
        rect.size.height = 16;
        _pageControl = [[SMPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl setPageIndicatorImage:[UIImage imageNamed:@"pagecontrol_ico_inactive.png"]];
        [_pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"pagecontrol_ico_active.png"]];
        
        [self addSubview:_pageControl];
        
        _curPage = 0;
        _autoCycle = autoCycle;
        
        self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_scrollView addGestureRecognizer:_singleTap];
    }
    return self;
}

- (void)setDataource:(id<XLCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    if (_datasource) {
        [self reloadPages];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    }
}

- (void)switchFocusImageItems {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_totalPages > 1 && _autoCycle) {
        //always show middle image
        _isAutoCycling = YES;
        [_scrollView setUserInteractionEnabled:NO];
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0) animated:YES];
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SCROLL_TIMEINTERVAL inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)reloadPages
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        if ([_datasource respondsToSelector:@selector(loadingview:)]) {
            UIView *loadingView = [_datasource loadingview:self];
            [self addSubview:loadingView];
            loadingView.tag = TAG_LOADING_VIEW;
        }
        for (UIView *vi in _curViews) {
            [vi removeFromSuperview];
        }
        [_curViews removeAllObjects];
        _curViews = nil;
        return;
    } else {
        [[self viewWithTag:TAG_LOADING_VIEW] removeFromSuperview];
    }
    
    if (_totalPages > 1) {
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        [self setShowPageControl:YES];
    } else {
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        [self setShowPageControl:NO];
    }
    
    _curPage = 0;
    _currentPage = 0;
    [self.pageControl setCurrentPage:_curPage];
//    [_scrollView setContentOffset:CGPointZero];
    
//    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
    
    if (_totalPages > 1 && _autoCycle) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SCROLL_TIMEINTERVAL inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)startCycling {
    if (_totalPages > 1 && _autoCycle && !_isAutoCycling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SCROLL_TIMEINTERVAL inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)stopCycling {
    if (_totalPages > 1 && _autoCycle && _isAutoCycling) {
        _isAutoCycling = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
        
        CGFloat x = self.scrollView.contentOffset.x;
        if (x == self.frame.size.width) {
            return;
        }
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    }
}

- (void)loadData
{
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (_datasource != nil) {
        [self getDisplayImagesWithCurpage:_curPage];
    }
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    [_scrollView setUserInteractionEnabled:YES];
}

- (void)getDisplayImagesWithCurpage:(int)page {
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    [_curViews removeAllObjects];
    if (pre >= 0 && pre < _totalPages) {
        [_curViews addObject:[_datasource pageAtIndex:pre frame:self.bounds]];
    }
    if (page >= 0 && page < _totalPages) {
        [_curViews addObject:[_datasource pageAtIndex:page frame:self.bounds]];
    }
    if (last >= 0 && last < _totalPages) {
        [_curViews addObject:[_datasource pageAtIndex:last frame:self.bounds]];
    }
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

- (void)setShowPageControl:(BOOL)showPageControl {
    [self.pageControl setHidden:!showPageControl];
}

- (void)setShouldPagingEnabled:(BOOL)enable {
    [self.scrollView setPagingEnabled:enable];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (_totalPages == 0) {//prohibit useless scroll event
        return;
    }
    int x = aScrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_isAutoCycling) {
            [_scrollView setUserInteractionEnabled:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    if (_isAutoCycling) {
        [_scrollView setUserInteractionEnabled:YES];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}

@end
