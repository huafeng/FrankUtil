//
//  NSString+CMExtension.h
//  LabaAssignment
//
//  Created by John on 12-12-13.
//  Copyright (c) 2012年 John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CMExtension)

//format as -->> 附近 20m 130m 400m 1.5km 9.7km 13km 234km ...  souceString (m)
+(NSString*)formateDistance:(float)distance;
-(BOOL)isValidPhoneNumber;
-(BOOL)isValidEmailAddress;
+(NSString*)formateDateStringWithYearAndMonth:(NSString*)year month:(NSString*)month;
-(BOOL)isAllNumbers;
-(BOOL)isAllLetters;

-(NSString *)md5;

@end
