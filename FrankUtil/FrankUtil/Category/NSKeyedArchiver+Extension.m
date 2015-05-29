//
//  NSKeyedArchiver+MWKeyedArchiver.m
//  MagicWindow
//
//  Created by JackLiu on 14-7-23.
//  Copyright (c) 2014年 MagicWindow. All rights reserved.
//

#import "NSKeyedArchiver+Extension.h"

@implementation NSKeyedArchiver (Extension)

+ (void)archiveObject:(id)object toPath:(NSString *)path
{
    NSString *pathDomain = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath = [pathDomain stringByAppendingPathComponent:path];
    [[NSFileManager defaultManager]removeItemAtPath:filepath  error:nil];
    
    if (object)
    {
        [NSKeyedArchiver archiveRootObject:object toFile: filepath];
    }
}

+ (id)unarchiveObjectWithPath:(NSString *)path
{
    NSString *pathDomain = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath = [pathDomain stringByAppendingPathComponent:path];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile: filepath];
}

+ (void)clearArchive:(NSString *)path
{
    NSString *pathDomain = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath = [pathDomain stringByAppendingPathComponent:path];
    [[NSFileManager defaultManager] removeItemAtPath: filepath error: nil];
}

@end
