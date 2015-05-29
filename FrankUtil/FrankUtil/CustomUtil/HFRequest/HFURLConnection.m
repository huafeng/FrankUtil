//
//  HFURLConnection.m
//  LaBaForB
//
//  Created by Admin on 15/2/2.
//  Copyright (c) 2015年 softlit. All rights reserved.
//

#import "HFURLConnection.h"

@implementation HFURLConnection
@synthesize tag;
@synthesize data;
@synthesize response;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate
{
    self=[super initWithRequest:request delegate:delegate];
    if (self) {
        NSMutableData *responseData=[[NSMutableData alloc] init];
        self.data=responseData;
#if !__has_feature(objc_arc)
        [responseData release];
#endif
        
        self.tag=[[NSProcessInfo processInfo] globallyUniqueString];
    }
    return self;
}

- (void)dealloc
{
    self.tag=nil;
    self.data=nil;
    self.response=nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end
