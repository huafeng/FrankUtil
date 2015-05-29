//
//  NSArray+MutableDeepCopy.m
//  YouJia
//
//  Created by aa on 14-9-16.
//
//

#import "NSArray+MutableDeepCopy.h"

@implementation NSArray (MutableDeepCopy)

-(NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id value in self)
    {
        id oneCopy = nil;
        
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
        {
            oneCopy = [value mutableDeepCopy];
        }
        else
        {
#if !__has_feature(objc_arc)
            oneCopy = [[value copy] autorelease];
#else
            oneCopy = [value copy];
#endif
        }
        
        if (oneCopy) {
            [list addObject:oneCopy];
        }
    }
#if !__has_feature(objc_arc)
    return [list autorelease];
#else
    return list;
#endif
}

@end
