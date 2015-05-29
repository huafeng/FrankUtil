//
//  NSDictionary+MutableDeepCopy.m
//  YouJia
//
//  Created by aa on 14-6-16.
//
//

#import "NSDictionary+MutableDeepCopy.h"

@implementation NSDictionary (MutableDeepCopy)

-(NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    //新建一个NSMutableDictionary对象，大小为原NSDictionary对象的大小
    NSArray *keys = [self allKeys];
    for (id key in keys)
    {
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        
        if ([oneValue isKindOfClass:[NSDictionary class]] || [oneValue isKindOfClass:[NSArray class]])
        {
            oneCopy = [oneValue mutableDeepCopy];
        }
        else
        {
#if !__has_feature(objc_arc)
            oneCopy = [[oneValue copy] autorelease];
#else
            oneCopy= [oneValue copy];
#endif
        }
        if (oneCopy) {
            [dict setValue:oneCopy forKey:key];
        }
    }
#if !__has_feature(objc_arc)
    return [dict autorelease];
#else
    return dict;
#endif
}

@end
