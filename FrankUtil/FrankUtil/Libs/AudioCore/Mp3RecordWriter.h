//
//  Mp3RecordWriter.h
//  MLRecorder
//
//  Created by molon on 5/13/14.
//  Copyright (c) 2014 molon. All rights reserved.
//
/**
 *  一般使用采样率 8000 缓冲区秒数为0.5
 *
 */
#import <Foundation/Foundation.h>

#import "MLAudioRecorder.h"
@interface Mp3RecordWriter : NSObject<FileWriterForMLAudioRecorder>

//@property (nonatomic, copy) NSString *filePath;
///**
// *  最终生成的mp3文件时间长度
// */
//@property (nonatomic, assign) unsigned long maxFileSize;
///**
// *  最终生成的mp3文件最大大小(M)
// */
//@property (nonatomic, assign) double maxSecondCount;

@end
