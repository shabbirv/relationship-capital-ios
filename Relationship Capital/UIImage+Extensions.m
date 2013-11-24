//
//  UIImage+Extensions.m
//  Ask Away
//
//  Created by Shabbir Vijapura on 8/8/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "UIImage+Extensions.h"
#import <Accelerate/Accelerate.h>

static int16_t gaussianblur_kernel[13] = {
    1, 12, 66, 220, 495, 792, 924, 792, 495, 220, 66, 12, 1
};

@implementation UIImage (Extensions)

- (UIImage *)imageScaledToSize:(CGSize)size
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (UIImage *)imageScaledToFitSize:(CGSize)size
{
    //calculate rect
    CGFloat aspect = self.size.width / self.size.height;
    if (size.width / aspect <= size.height)
    {
        return [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

-(UIImage *)blurImageWithPoint:(NSUInteger)point
{
    NSInteger index = point * 2 * self.scale + 1;
    int16_t kernel[index];
    for (NSInteger i = 0; i < index; i++) {
        kernel[i] = 1;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawAtPoint:CGPointZero];
    
    size_t width = CGBitmapContextGetWidth(ctx);
    size_t height = CGBitmapContextGetHeight(ctx);
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(ctx);
    
    UInt8 *data = CGBitmapContextGetData(ctx);
    
    vImage_Buffer src = {data, height, width, bytesPerRow};
    
    vImageConvolve_ARGB8888(&src, &src, NULL, 0, 0, kernel , index, 1, index, NULL, kvImageEdgeExtend);
    vImageConvolve_ARGB8888(&src, &src, NULL, 0, 0, kernel, 1, index, index, NULL, kvImageEdgeExtend);
    
    UIImage *blurImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blurImage;
}

-(UIImage *)gaussianBlurImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawAtPoint:CGPointZero];
    
    size_t width = CGBitmapContextGetWidth(ctx);
    size_t height = CGBitmapContextGetHeight(ctx);
    size_t bitsPerComponent = CGBitmapContextGetBitsPerComponent(ctx);
    size_t bitsPerPixcel = CGBitmapContextGetBitsPerPixel(ctx);
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(ctx);
    
    NSLog(@"%ld, %ld, %ld, %ld, %ld", width, height, bitsPerComponent, bitsPerPixcel, bytesPerRow);
    
    UInt8 *data = CGBitmapContextGetData(ctx);
    
    vImage_Buffer src = {data, height, width, bytesPerRow};
    
    vImageConvolve_ARGB8888(&src, &src, NULL, 0, 0, gaussianblur_kernel, 13, 1, 4096, NULL, kvImageEdgeExtend);
    vImageConvolve_ARGB8888(&src, &src, NULL, 0, 0, gaussianblur_kernel, 1, 13, 4096, NULL, kvImageEdgeExtend);
    
    UIImage *blurImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blurImage;
}


@end
