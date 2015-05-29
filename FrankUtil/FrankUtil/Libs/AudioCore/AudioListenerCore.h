//
//  AudioListenerCore.h
//  CategoryUtil
//
//  Created by Admin on 15/3/16.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define KAudioReceiveBeginInterruptionNotification @"AudioReceiveBeginInterruptionNotification"
#define KAudioReceiveEndInterruptionNotification @"AudioReceiveEndInterruptionNotification"

@interface AudioListenerCore : NSObject

@property (nonatomic, assign) BOOL hadRegisterAudioListener;

//单例初始化
+ (id)defaultListener;

- (void)registerAudioListener;

@end
