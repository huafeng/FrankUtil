//
//  ImageService.h
//  YouJia
//
//  Created by J on 11-6-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ImageService : NSObject {
    
}

CGAffineTransform orientationTransformForImage(UIImage *image, CGSize *newSize);

UIImage *straightenAndScaleImage(UIImage *image, int maxDimension);

+(UIImage*)straightenAndScaleImage:(UIImage *)image maxDimension:(int) maxDimension;

+(UIImage*)editedImageFromMediaWithInfo:(NSDictionary*)info;

+(UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect andScaleTo:(CGSize)size;

+(UIImage*)scaleImage:(UIImage*)anImage withEditingInfo:(NSDictionary*)editInfo;

+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(CGFloat)radius;
+ (UIImage *)createDesaturateImage:(UIImage *)image desaturation:(CGFloat)desaturation;
//将图像和文字合成一张图片
//@param    inImage    传入的图像
//@param    str        传入的文字
//@param    font       文字字体
//@param    color      文字颜色
//@param    spacting   图片和文字间的间隙
//@return   UIImage    合并后的图片
+ (UIImage *)creatImage:(UIImage *)inImage 
             withString:(NSString *)str 
                andFont:(UIFont *)font 
               andColor:(UIColor *)color 
             andSpacing:(CGFloat)spacting;

+(UIImage*)getGrayImage:(UIImage*)sourceImage;

+ (UIImage *)blurImage:(UIImage *)image;

+ (UIImage *)blurImage:(UIImage *)image withRadius:(CGFloat)radius maskColor:(UIColor *)color;

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
