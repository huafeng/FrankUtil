//
//  HFURLConnection.h
//  LaBaForB
//
//  Created by Admin on 15/2/2.
//  Copyright (c) 2015年 softlit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFURLConnection : NSURLConnection

@property(nonatomic, strong) NSString *tag;   //唯一标识
@property(nonatomic, strong) NSMutableData *data;  //存放请求返回数据
@property(nonatomic, strong) NSHTTPURLResponse *response;  //请求返回的结果码


@end
