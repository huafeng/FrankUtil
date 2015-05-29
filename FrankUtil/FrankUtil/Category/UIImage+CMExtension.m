//
//  UIImage+CMExtension.m
//  LabaAssignment
//
//  Created by John on 12-12-6.
//  Copyright (c) 2012年 John. All rights reserved.
//

#import "UIImage+CMExtension.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (CMExtension)

+(UIImage*)imageWithBundleFilePathImageName:(NSString*)imageName;{
    
    NSString *path=[[NSBundle mainBundle] pathForResource:imageName ofType:@""];
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (UIImage *)imageInDocumentDirectoryWithPath:(NSString *)path secondLevelDirectory:(NSString *)secondLevelDirectory {
    if ([path length] == 0) {
        return nil;
    }
    NSString *newPath = [UIImage imagePathInDocumentDirectoryWithPath:path secondLevelDirectory:secondLevelDirectory];
    return [UIImage imageWithContentsOfFile:newPath];
}

+ (NSString *)imagePathInDocumentDirectoryWithPath:(NSString *)path secondLevelDirectory:(NSString *)secondLevelDirectory {
    NSString *document = [[UIImage applicationDocumentsDirectory] lastPathComponent];
    if ([secondLevelDirectory length] > 0) {
        NSRange range = [path rangeOfString:secondLevelDirectory];
        if (range.location == NSNotFound) {
            NSRange range = [path rangeOfString:document];
            if (range.location == NSNotFound) {
                NSString *newPath = [NSString stringWithFormat:@"%@%@",[UIImage applicationDocumentsDirectory],path];
                return newPath;
            } else {
                NSString *newSubPath = [path substringFromIndex:range.location];
                NSString *newPath = [NSString stringWithFormat:@"%@%@",[UIImage applicationDocumentsDirectory],newSubPath];
                return newPath;
            }
        } else {
            NSString *newSubPath = [path substringFromIndex:range.location];
            NSString *newPath = [NSString stringWithFormat:@"%@/%@",[UIImage applicationDocumentsDirectory],newSubPath];
            return newPath;
        }
    } else {
        NSRange range = [path rangeOfString:document];
        if (range.location == NSNotFound) {
            NSString *newPath = [NSString stringWithFormat:@"%@%@",[UIImage applicationDocumentsDirectory],path];
            return newPath;
        } else {
            NSString *newSubPath = [path substringFromIndex:range.location];
            NSString *newPath = [NSString stringWithFormat:@"%@%@",[UIImage applicationDocumentsDirectory],newSubPath];
            return newPath;
        }
    }
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        //NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)compressedImageWithMaxPix:(CGFloat)maxPix{
    
    CGSize imageSize = self.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    
    if (width <= maxPix && height<= maxPix) {
        
        // no need to compress.
        
        return self;
        
    }
    
    
    if (width == 0 || height == 0) {
        
        // void zero exception
        
        return self;
    }
    
    UIImage *newImage = nil;
    
    CGFloat widthFactor = maxPix / width;
    
    CGFloat heightFactor = maxPix / height;
    
    CGFloat scaleFactor = 0.0;
    
    if (widthFactor > heightFactor)
        
        scaleFactor = heightFactor; // scale to fit height
    
    else
        
        scaleFactor = widthFactor; // scale to fit width
    
    CGFloat scaledWidth  = width * scaleFactor;
    
    CGFloat scaledHeight = height * scaleFactor;
    
    
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.size.width  = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    //pop the context to get back to the default
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (NSData *)compressedDataWithBytes:(NSInteger)bytes{
    
    CGFloat quality = 1;
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    
    NSUInteger dataLength = [data length];
//    NSLog(@">>%d----->>%d",dataLength,bytes);
    if(dataLength>bytes*4.0) {

        quality=(CGFloat)bytes*4.0/dataLength;
        
    }
    else{

        quality=(CGFloat)bytes/dataLength;
    }
//    NSLog(@"---->>%f",quality);
    return UIImageJPEGRepresentation(self, quality);
    
}


+(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef){
    
        return nil;
        
    }else{
    
    
        UIImage *img=[[UIImage alloc] initWithCGImage:thumbnailImageRef];
        
        CGImageRelease(thumbnailImageRef);
        
        return img;
    }
        
}


@end

