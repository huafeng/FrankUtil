//
//  CalendarDateUtil.h
//  EvenTouch
//
//  Created by Jack Liu on 14-5-9.
//  Copyright (c) 2014年 Jack Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLCalendarDateUtil : NSObject

+ (BOOL)isLeapYear:(NSInteger)year;
/*
 * @abstract caculate number of days by specified month and current year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month;

/*
 获取指定月份拥有多少天
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year;

/*
 获取当前年份
 */
+ (NSInteger)getCurrentYear;

/*
 获取当前月份
 */
+ (NSInteger)getCurrentMonth;

/*
 获取当前日期
 */
+ (NSInteger)getCurrentDay;

/*
 获取月份中有多少天
 */
+ (NSInteger)getMonthWithDate:(NSDate*)date;

+ (NSInteger)getDayWithDate:(NSDate*)date;

+ (NSDate*)dateSinceNowWithInterval:(NSInteger)dayInterval;

+ (NSString *)weekDateWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger) year;

+ (NSString *)getStringFromDate:(NSDate *)date;

+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format;

@end
