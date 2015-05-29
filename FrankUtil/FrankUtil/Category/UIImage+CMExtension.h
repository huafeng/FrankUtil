//
//  UIImage+CMExtension.h
//  LabaAssignment
//
//  Created by John on 12-12-6.
//  Copyright (c) 2012年 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CMExtension)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (NSData *)compressedDataWithBytes:(NSInteger)bytes;
- (UIImage *)compressedImageWithMaxPix:(CGFloat)maxPix;
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

+(UIImage*)imageWithBundleFilePathImageName:(NSString*)imageName;
+ (UIImage *)imageInDocumentDirectoryWithPath:(NSString *)path secondLevelDirectory:(NSString *)secondLevelDirectory;
+ (NSString *)imagePathInDocumentDirectoryWithPath:(NSString *)path secondLevelDirectory:(NSString *)secondLevelDirectory;

@end
