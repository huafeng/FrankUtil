//
//  UIColor+Hex.m
//  YouJia
//
//  Created by J on 13-5-22.
//
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (NSUInteger)integerValueFromHexString:(NSString *)hex
{
	int result = 0;
	sscanf([hex UTF8String], "%x", &result);
	return result;
}

+ (UIColor *)colorWithHexString:(NSString *)hex
{
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([hex length]!=6 && [hex length]!=3)
	{
		return nil;
	}
	
	NSUInteger digits = [hex length]/3;
	CGFloat maxValue = (digits==1)?15.0:255.0;
	
	CGFloat red = [self integerValueFromHexString:[hex substringWithRange:NSMakeRange(0, digits)]]/maxValue;
	CGFloat green = [self integerValueFromHexString:[hex substringWithRange:NSMakeRange(digits, digits)]]/maxValue;
	CGFloat blue = [self integerValueFromHexString:[hex substringWithRange:NSMakeRange(2*digits, digits)]]/maxValue;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
