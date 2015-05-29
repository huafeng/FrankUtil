//
//  AudioPlayer.m
//  AudioTest
//
//  Created by John on 15/1/17.
//  Copyright (c) 2015年 com.yiyu.co.,Ltd. All rights reserved.
//

#import "AudioPlayer.h"
#import <UIKit/UIKit.h>
#import "AudioListenerCore.h"

@interface AudioPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIProgressView *progressV;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy)   NSString *filePath;

@end

@implementation AudioPlayer

- (id)initWithFilePath:(NSString *)path {
    self = [super init];
    if (self) {
        self.filePath = path;
        NSURL *url = [NSURL fileURLWithPath:self.filePath];
        [self initPlayerWithUrl:url];
        [[AudioListenerCore defaultListener] registerAudioListener];
        [self addInterruptionListener];
        [self setDefaultRoute];
        [self addRouteChangedListener];
    }
    return self;
}

- (id)initWithFileUrl:(NSString *)path {
    self = [super init];
    if (self) {
        self.filePath = path;
        NSURL *url = [NSURL URLWithString:path];
        [self initPlayerWithUrl:url];
        [[AudioListenerCore defaultListener] registerAudioListener];
        [self addInterruptionListener];
    }
    return self;
}

- (void)initPlayerWithUrl:(NSURL *)url
{
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _avAudioPlayer.delegate = self;
    _avAudioPlayer.volume = 0.5;
    _avAudioPlayer.currentTime = 0;
    _avAudioPlayer.numberOfLoops = 0;
    [_avAudioPlayer prepareToPlay];
}

- (void)addInterruptionListener {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginInterruptionAction) name:KAudioReceiveBeginInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endInterruptionAction) name:KAudioReceiveEndInterruptionNotification object:nil];
}

- (void)removeInterruptionListener {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KAudioReceiveBeginInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KAudioReceiveEndInterruptionNotification object:nil];
}

- (void)beginInterruptionAction {
    //NSLog(@"打断,停止播放");
    if (self.receiveBeginInterruptionBlock) {
        self.receiveBeginInterruptionBlock();
    }
}

- (void)endInterruptionAction {
    //NSLog(@"从打断中恢复,继续播放");
    if (self.receiveEndInterruptionBlock) {
        self.receiveEndInterruptionBlock();
    }
}

//#pragma mark - interruption logic -
//void interruptionPlayListenner(void* inClientData, UInt32 inInterruptionState) {
//    AudioPlayer* this = (__bridge AudioPlayer *)inClientData;
//    if (kAudioSessionBeginInterruption == inInterruptionState) {
//        if (this.receiveBeginInterruptionBlock) {
//            this.receiveBeginInterruptionBlock();
//        }
//        [this pause];
//    }
//    else {
//        if (this.receiveEndInterruptionBlock) {
//            this.receiveEndInterruptionBlock();
//        }
//        [this play];
//    }
//}

- (void)startTimer {
    if (_timer && [_timer isValid]) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(playProgress)                                                     userInfo:nil
                                                   repeats:YES];
}

- (void)stopTimer {
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
    }
    _timer = nil;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    [_avAudioPlayer setCurrentTime:_avAudioPlayer.duration * _progress];

}

- (void)setVolume:(float)volume {
    _volume = volume;
    [_avAudioPlayer setVolume:_volume];
}

- (void)playProgress {
    if ([_delegate respondsToSelector:@selector(audioPlayer:playingWithProgress:currentTimeSeconds:)]) {
        [_delegate audioPlayer:self playingWithProgress:(_avAudioPlayer.currentTime/_avAudioPlayer.duration) currentTimeSeconds:_avAudioPlayer.currentTime];
    }
}

- (void)play {
    if ([_avAudioPlayer isPlaying]) {
        return;
    }
    [_avAudioPlayer play];
    [self startTimer];
}

- (void)pause {
    if (self.receivePauseBlock) {
        self.receivePauseBlock();
    }
    [_avAudioPlayer pause];
    [self stopTimer];
}

- (void)stop {
    [_avAudioPlayer stop];
    _avAudioPlayer.currentTime = 0;
    [self stopTimer];
    if ([_delegate respondsToSelector:@selector(audioPlayerDidFinish:)]) {
        [_delegate audioPlayerDidFinish:self];
    }
}

#pragma mark - AVAudioPlayerDelegate method -
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopTimer];
    if ([_delegate respondsToSelector:@selector(audioPlayerDidFinish:)]) {
        [_delegate audioPlayerDidFinish:self];
    }
    _avAudioPlayer.currentTime = 0;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(audioPlayerErrorWithDecode:)]) {
        [_delegate audioPlayerErrorWithDecode:self];
    }
}

- (void)addRouteChangedListener {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioHardwareRouteChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    } else {
        AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                        audioPlayerRouteChangeListenerCallback,
                                        (__bridge void *)(self));
    }
}

- (void)removeRouteListener {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    } else {
        AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioPlayerRouteChangeListenerCallback, (__bridge void *)(self));
    }
}

- (void)audioHardwareRouteChanged:(NSNotification *)notification {
    NSInteger routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    if (routeChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        [self setDefaultRoute];
    }
}

void audioPlayerRouteChangeListenerCallback(void *inUserData,
                                      AudioSessionPropertyID inPropertyID,
                                      UInt32 inPropertyValueSize,
                                      const void *inPropertyValue) {
    CFDictionaryRef routeChangeDictionary = inPropertyValue;
    CFNumberRef routeChangeReasonRef = CFDictionaryGetValue (routeChangeDictionary,
                                                             CFSTR (kAudioSession_AudioRouteChangeKey_Reason));
    SInt32 routeChangeReason;
    CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
        AudioPlayer *this = (__bridge AudioPlayer *)inUserData;
        [this setDefaultRoute];
    }
}

- (void)setDefaultRoute {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        AVAudioSession* session = [AVAudioSession sharedInstance];
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    } else {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    }
}

- (void)dealloc
{
    ////NSLog(@"dealloc player ...");
    [self removeInterruptionListener];
    [self removeRouteListener];
    _receivePauseBlock = nil;
    _receiveBeginInterruptionBlock = nil;
    _receiveEndInterruptionBlock = nil;
}

@end
