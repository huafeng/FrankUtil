//
//  UIAlertView+Utilities.h
//  CarGuide
//
//  Created by  litong on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *
 * UIAlertView (Utilities) 集合
 *
 *   1.为SDK自带的 UIAlertView 类添加一些实用方法
 *
 * @InterfaceName:   UIAlertView (Utilities)
 * @date:            2011-12-30
 */
@interface UIAlertView (Utilities)

/* 获取当前实例 */
+(UIAlertView *)getInstance;

/* 销毁当前实例 */
+(void)Destroy;

/* 隐藏当前实例 */
+(void)hiddenTips;

/* 显示提示信息 */
+(void)showTips:(NSString *)tips;

/* 显示提示信息（可设定自动隐藏时间） */
+(void)showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

/* 显示提示信息（可设定是否显示转子） */
+(void)showTips:(NSString *)tips showIndicator:(BOOL)showIndicator;

/* 显示提示信息（可设定自动隐藏时间、是否显示转子） */
+(void)showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

/* 显示提示对话框 */
+(UIAlertView *)showAlert:(NSString *)msg;

+(UIAlertView *)showAlert:(NSString *)title message:(NSString *)msg; 

/* 显示提示对话框(withDelegate) */
+(UIAlertView *)showAlert:(NSString *)msg withDelegate:(id<UIAlertViewDelegate>)delegate;

/* Show confirm message */
+(UIAlertView *)showConfirm:(NSString *)msg withDelegate:(id<UIAlertViewDelegate>)delegate;

+(UIAlertView *)showConfirm:(NSString *)title message:(NSString *)msg withDelegate:(id<UIAlertViewDelegate>)delegate;

/* 设定时间内自动隐藏视图 */
-(void)hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

/* 隐藏提示视图 */
-(void)hiddenAlertView;

/* 获取提示文本控件 */
-(UILabel *)getTipsTextLabel;

@end
