//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLCycleScrollViewDelegate;
@protocol XLCycleScrollViewDatasource;

@class SMPageControl;

@interface XLCycleScrollView : UIView<UIScrollViewDelegate>

@property (atomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) SMPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<XLCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<XLCycleScrollViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *curViews;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) BOOL autoCycle;

- (id)initWithFrame:(CGRect)frame autoCycle:(BOOL)autoCycle;
- (void)reloadPages;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
- (void)setShowPageControl:(BOOL)showPageControl;
- (void)setShouldPagingEnabled:(BOOL)enable;
- (void)startCycling;
- (void)stopCycling;

@end

@protocol XLCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol XLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index frame:(CGRect)maxFrame;
@optional
- (UIView *)loadingview:(XLCycleScrollView *)cycleView;
@end
