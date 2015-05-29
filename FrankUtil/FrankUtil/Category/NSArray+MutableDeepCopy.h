//
//  NSArray+MutableDeepCopy.h
//  YouJia
//
//  Created by aa on 14-9-16.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (MutableDeepCopy)

//深拷贝方法，不需要释放
-(NSMutableArray *)mutableDeepCopy;

@end
