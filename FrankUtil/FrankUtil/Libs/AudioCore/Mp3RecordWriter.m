//
//  Mp3RecordWriter.m
//  MLRecorder
//
//  Created by molon on 5/13/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "Mp3RecordWriter.h"
#import "lame.h"

@interface Mp3RecordWriter()
{
    FILE *_file;
    lame_t _lame;
}

@property (nonatomic, assign) unsigned long recordedFileSize;
@property (nonatomic, assign) double recordedSecondCount;

@end

@implementation Mp3RecordWriter


- (BOOL)createFileWithRecorder:(MLAudioRecorder*)recoder {
    // mp3压缩参数
    _lame = lame_init();
    lame_set_num_channels(_lame, recoder.numChannels);//1:单声道 2:双声道
    lame_set_in_samplerate(_lame, recoder.sampleRate);//采样率
    lame_set_out_samplerate(_lame, recoder.sampleRate);
    lame_set_brate(_lame, recoder.outputBitRate);//码率
    // 0:立体声  1:联合立体声,比Stereo更高的压缩率 2:dual channel未实现  3:单声道
    if (recoder.numChannels == 1) {
        lame_set_mode(_lame, 3);
    } else {
        lame_set_mode(_lame, 0);
    }
    lame_set_quality(_lame, recoder.outputQuality);//5:good quality, fast   7:ok quality, really fast
    lame_init_params(_lame);
    
    //建立mp3文件
    _file = fopen((const char *)[recoder.outputFilePath UTF8String], "wb+");
    if (_file==0) {
        //NSLog(@"建立文件失败:%s",__FUNCTION__);
        return NO;
    }
    
    self.recordedFileSize = 0;
    self.recordedSecondCount = 0;
    
    //NSLog(@"filePath:%@",recoder.outputFilePath);
    
    return YES;
    
}

- (BOOL)writeIntoFileWithData:(NSData*)data withRecorder:(MLAudioRecorder*)recoder inAQ:(AudioQueueRef)						inAQ inStartTime:(const AudioTimeStamp *)inStartTime inNumPackets:(UInt32)inNumPackets inPacketDesc:(const AudioStreamPacketDescription*)inPacketDesc
{
    if (recoder.outputMaxTimeSeconds > 0){
        if (self.recordedSecondCount+recoder.bufferDurationSeconds > recoder.outputMaxTimeSeconds){
            //NSLog(@"录音超时");
            dispatch_async(dispatch_get_main_queue(), ^{
                [recoder stopRecording];
            });
            return YES;
        }
        self.recordedSecondCount += recoder.bufferDurationSeconds;
    }
    
    //编码
    short *recordingData = (short*)data.bytes;
    int pcmLen = data.length;
    if (pcmLen<2){
        return YES;
    }
    int nsamples = pcmLen / 2;
    unsigned char buffer[pcmLen];
    // mp3 encode
    int recvLen;
    if (recoder.numChannels == 1) {
        recvLen = lame_encode_buffer(_lame, recordingData, recordingData, nsamples, buffer, pcmLen);
    } else {
        recvLen = lame_encode_buffer_interleaved(_lame, recordingData , inNumPackets, buffer, pcmLen);
    }
    // add NSMutable
    if (recvLen>0) {
        if (recoder.outputMaxFileSize > 0){
            if(self.recordedFileSize+recvLen > recoder.outputMaxFileSize){
                //NSLog(@"录音文件过大");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [recoder stopRecording];
                });
                return YES;//超过了最大文件大小就直接返回
            }
        }
        
        if(fwrite(buffer,1,recvLen,_file)==0){
            return NO;
        }
        self.recordedFileSize += recvLen;
    }
    
    return YES;
}

- (BOOL)completeWriteWithRecorder:(MLAudioRecorder*)recoder withIsError:(BOOL)isError
{
    if(_file){
        fclose(_file);
        _file = 0;
    }
    
    if(_lame){
        lame_close(_lame);
        _lame = 0;
    }
    
    return YES;
}

- (void)dealloc
{
	if(_file){
        fclose(_file);
        _file = 0;
    }
    
    if(_lame){
        lame_close(_lame);
        _lame = 0;
    }
}


@end
