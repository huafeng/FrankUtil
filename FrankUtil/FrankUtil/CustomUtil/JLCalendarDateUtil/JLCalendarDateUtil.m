//
//  CalendarDateUtil.m
//  EvenTouch
//
//  Created by Jack Liu on 14-5-9.
//  Copyright (c) 2014年 Jack Liu. All rights reserved.
//

#import "JLCalendarDateUtil.h"

@implementation JLCalendarDateUtil

+ (BOOL)isLeapYear:(NSInteger)year
{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = FALSE;
    if ((0 == (year % 400))) {
        leap = TRUE;
    }
    else if((0 == (year%4)) && (0 != (year % 100))) {
        leap = TRUE;
    }
    return leap;
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month
{
    return [JLCalendarDateUtil numberOfDaysInMonth:month year:[JLCalendarDateUtil getCurrentYear]];
}

/*
 获取当前年份
 */
+ (NSInteger)getCurrentYear
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int year = dt->tm_year + 1900;
    return year;
}

/*
 获取当前月份
 */
+ (NSInteger)getCurrentMonth
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int month = dt->tm_mon + 1;
    return month;
}

/*
 获取当前日期
 */
+ (NSInteger)getCurrentDay
{
    time_t ct = time(NULL);
	struct tm *dt = localtime(&ct);
	int day = dt->tm_mday;
    return day;
}

+ (NSInteger)getMonthWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger month = comps.month;
    return month;
}

+ (NSInteger)getDayWithDate:(NSDate*)date
{
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSInteger day = comps.day;
    return day;
}

/*
 获取指定月份拥有多少天
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year
{
    NSAssert(!(month < 1||month > 12), @"invalid month number");
    NSAssert(!(year < 1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    NSInteger days = daysOfMonth[month];
 
    if (month == 1)
    {
        if ([JLCalendarDateUtil isLeapYear:year])
        {
            days = 29;
        }
        else
        {
            days = 28;
        }
    }
    return days;
}

+ (NSDate*)dateSinceNowWithInterval:(NSInteger)dayInterval
{
    return [NSDate dateWithTimeIntervalSinceNow:dayInterval*24*60*60];
}

+ (NSString *)weekDateWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger) year
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    [comp setDay:day];
    [comp setMonth:month];
    [comp setYear:year];
    
    NSDate *date = [gregorian dateFromComponents:comp];
    
    NSCalendar *_calendar=[NSCalendar currentCalendar];
    NSInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *com=[_calendar components:unitFlags fromDate:date];
    NSString *_dayNum=@"";
    
    NSInteger dayInt = 0;
    switch ([com weekday]) {
        case 1:{
            _dayNum=@"日";
            dayInt = 1;
            break;
        }
        case 2:{
            _dayNum=@"一";
            dayInt = 2;
            break;
        }
        case 3:{
            _dayNum=@"二";
            dayInt = 3;
            break;
        }
        case 4:{
            _dayNum=@"三";
            dayInt = 4;
            break;
        }
        case 5:{
            _dayNum=@"四";
            dayInt = 5;
            break;
        }
        case 6:{
            _dayNum=@"五";
            dayInt = 6;
            break;
        }
        case 7:{
            _dayNum=@"六";
            dayInt = 7;
            break;
        }
            
        default:
            break;
    }
    
    return _dayNum;
}

+ (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format
{
    //yyyy-MM-dd HH:mm:ss
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


@end
