//
//  UIImage+Extensions.h
//  Ask Away
//
//  Created by Shabbir Vijapura on 8/8/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage *)blurImageWithPoint:(NSUInteger)point;
- (UIImage *)gaussianBlurImage;

@end
