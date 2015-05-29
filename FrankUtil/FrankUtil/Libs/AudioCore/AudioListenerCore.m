//
//  AudioListenerCore.m
//  CategoryUtil
//
//  Created by Admin on 15/3/16.
//
//

#import "AudioListenerCore.h"

@implementation AudioListenerCore

+ (id)defaultListener
{
    static AudioListenerCore *listener=nil;
    if (listener==nil) {
        listener=[[[self class] alloc] init];
    }
    
    return listener;
}

- (void)registerAudioListener
{
    if (!_hadRegisterAudioListener) {
        _hadRegisterAudioListener = YES;
        [self addAudioListener];
    }
}

- (void)addAudioListener {
    AudioSessionInitialize(NULL, NULL, interruptionRecordListenner, (__bridge void*)self);
}

void interruptionRecordListenner(void* inClientData, UInt32 inInterruptionState) {
    if (kAudioSessionBeginInterruption == inInterruptionState) {
        //        NSLog(@"打断Audio");
        [[NSNotificationCenter defaultCenter] postNotificationName:KAudioReceiveBeginInterruptionNotification object:nil];
    }
    else if (kAudioSessionEndInterruption == inInterruptionState) {
        //        NSLog(@"从打断中恢复Audio");
        [[NSNotificationCenter defaultCenter] postNotificationName:KAudioReceiveEndInterruptionNotification object:nil];
    }
}

@end
