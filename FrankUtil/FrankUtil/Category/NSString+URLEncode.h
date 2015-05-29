//
//  NSString+URLEncode.h
//  YouJia
//
//  Created by aa on 14-3-5.
//
//

#import <Foundation/NSString.h>

@interface NSString (URLEncodeString)

+ (NSString *)encodeString:(NSString*)unescapedString;

@end
