//
//  UIAlertView+Utilities.h
//  CarGuide
//
//  Created by  litong on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIAlertView+Utilities.h"
/* 字符转换 */
#define LOS(key) NSLocalizedString(key, nil)

@implementation UIAlertView (Utilities)

/* 获取或销毁当前实例，forDestroy 为true时代表销毁实例 */
+(UIAlertView *)getInstance:(BOOL)forDestroy {
    static UIAlertView *_tipsView = nil;

    if (forDestroy) {
        if (_tipsView != nil) {
            [_tipsView dismissWithClickedButtonIndex:0 animated:NO];
#if !__has_feature(objc_arc)
            [_tipsView release];
#endif
            _tipsView = nil;
        }
    } else {
        if (nil == _tipsView) {
            _tipsView = [[UIAlertView alloc] initWithTitle:nil
                                                   message:@""
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil
                               ];
        }
    }

    return _tipsView;
}

/* 获取当前实例 */
+(UIAlertView *)getInstance {
    return [UIAlertView getInstance:NO];
}

/* 销毁当前实例 */
+(void)Destroy {
    [UIAlertView getInstance:YES];
}

/* 隐藏当前实例 */
+(void)hiddenTips {
    [[UIAlertView getInstance] hiddenAlertView];
}

/* 显示提示信息 */
+(void)showTips:(NSString *)tips {
	[UIAlertView showTips:tips showIndicator:YES hiddenAfterSeconds:0];
}

/* 显示提示信息（可设定自动隐藏时间） */
+(void)showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
	[UIAlertView showTips:tips showIndicator:NO hiddenAfterSeconds:hiddenAfterSeconds];
}

/* 显示提示信息（可设定是否显示转子） */
+(void)showTips:(NSString *)tips showIndicator:(BOOL)showIndicator {
	[UIAlertView showTips:tips showIndicator:showIndicator hiddenAfterSeconds:0];
}

/* 显示提示对话框 */
+(UIAlertView *)showAlert:(NSString *)msg {
    return [UIAlertView showAlert:msg withDelegate:nil];
}

+(UIAlertView *)showAlert:(NSString *)title message:(NSString *)msg{
    [UIAlertView hiddenTips];
    
    if (nil == msg || [msg length] < 1) {
        return nil;
    }
    
	UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle: title
                                                       message: msg
                                                      delegate: nil
                                             cancelButtonTitle: LOS(@"确定")
                                             otherButtonTitles: nil];
	[tipsView show];
#if !__has_feature(objc_arc)
	[tipsView release];
#endif
    
    return tipsView;   
}

/* 显示提示对话框(withDelegate) */
+(UIAlertView *)showAlert:(NSString *)msg withDelegate:(id<UIAlertViewDelegate>)delegate {
	[UIAlertView hiddenTips];

    if (nil == msg || [msg length] < 1) {
        return nil;
    }

	UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle: nil
                                                       message: msg
                                                      delegate: delegate
                                             cancelButtonTitle: LOS(@"确定")
                                             otherButtonTitles: nil];
	[tipsView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
#if !__has_feature(objc_arc)
	[tipsView release];
#endif

    return tipsView;
}

/* Show confirm message */
+(UIAlertView *)showConfirm:(NSString *)msg withDelegate:(id<UIAlertViewDelegate>)delegate {
	UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle: nil
                                                       message: msg
                                                      delegate: delegate
                                             cancelButtonTitle: LOS(@"取消")
                                             otherButtonTitles: LOS(@"确定"), nil];
	[tipsView show];
#if !__has_feature(objc_arc)
	[tipsView release];
#endif

    return tipsView;
}

+(UIAlertView *)showConfirm:(NSString *)title message:(NSString *)msg withDelegate:(id<UIAlertViewDelegate>)delegate {
	UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle: title
                                                       message: msg
                                                      delegate: delegate
                                             cancelButtonTitle: LOS(@"取消")
                                             otherButtonTitles: LOS(@"确定"), nil];
	[tipsView show];
#if !__has_feature(objc_arc)
	[tipsView release];
#endif
    
    return tipsView;
}

/* 显示提示信息（可设定自动隐藏时间、是否显示转子） */
+(void)showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    [UIAlertView Destroy];

    if (nil == tips || [tips length] < 1) {
        return;
    }

    UIAlertView *tipsView = [UIAlertView getInstance];
    tipsView.message = tips;

    if (showIndicator) {
        UIActivityIndicatorView *indicator;
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.frame = CGRectMake(120.f, 48.0f, 37.0f, 37.0f);
        [indicator startAnimating];
        [tipsView addSubview:indicator];
#if !__has_feature(objc_arc)
        [indicator release];
#endif
    } else {
        UILabel *textLabel = [tipsView getTipsTextLabel];
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }

    [tipsView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];

	if(hiddenAfterSeconds > 0){
		[tipsView hiddenAfterSeconds:hiddenAfterSeconds];
	}
}

/* 设定时间内自动隐藏视图 */
-(void)hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
	[self performSelector:@selector(hiddenAlertView) withObject:nil afterDelay:hiddenAfterSeconds];
}

/* 隐藏提示视图 */
-(void)hiddenAlertView {
	[self dismissWithClickedButtonIndex:0 animated:NO];
}

/* 获取提示文本控件 */
-(UILabel *)getTipsTextLabel {
	for(UIView *view in self.subviews){
		if( [view isKindOfClass:[UILabel class]] ){
			return (UILabel*) view;
		}
	}

	return nil;
}

@end
