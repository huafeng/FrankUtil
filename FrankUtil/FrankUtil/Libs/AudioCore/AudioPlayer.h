//
//  AudioPlayer.h
//  AudioTest
//
//  Created by John on 15/1/17.
//  Copyright (c) 2015年 com.yiyu.co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^AudioPlayerReceivePauseBlock)();
typedef void (^AudioPlayerReceiveBeginInterruptionBlock)();
typedef void (^AudioPlayerReceiveEndInterruptionBlock)();

@protocol AudioPlayerDelegate;

@interface AudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, weak) id<AudioPlayerDelegate> delegate;
@property (nonatomic, copy) AudioPlayerReceivePauseBlock receivePauseBlock;
@property (nonatomic, copy) AudioPlayerReceiveBeginInterruptionBlock receiveBeginInterruptionBlock;
@property (nonatomic, copy) AudioPlayerReceiveEndInterruptionBlock receiveEndInterruptionBlock;

- (id)initWithFilePath:(NSString *)path;
- (id)initWithFileUrl:(NSString *)path;
- (void)play;
- (void)pause;
- (void)stop;
- (void)setProgress:(float)progress;
- (void)setVolume:(float)volume;

@end

@protocol AudioPlayerDelegate <NSObject>

@optional

- (void)audioPlayer:(AudioPlayer *)player playingWithProgress:(float)progress currentTimeSeconds:(float)currentTimeSeconds;
- (void)audioPlayerErrorWithDecode:(AudioPlayer *)player;
- (void)audioPlayerDidFinish:(AudioPlayer *)player;
@end