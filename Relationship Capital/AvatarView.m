//
//  AvatarView.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AvatarView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+AFNetworking.h"
#import "UIImage+Extensions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "EGOCache.h"

@implementation AvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapIcon:)];
        [self addGestureRecognizer:tap];
        
        _image = [UIImage imageNamed:@"no-image"];
        [self setNeedsDisplay];
        
    }
    return self;
}

- (void) awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapIcon:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];

    _image = [UIImage imageNamed:@"no-image"];
    [self setNeedsDisplay];

}

- (void)setShowShadow:(BOOL)showShadow {
    _showShadow = showShadow;
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.7f;
}

- (void)setImageUrl:(NSURL *)imageUrl {
    if (![[UIApplication sharedApplication] canOpenURL:imageUrl]) {
        _image = [UIImage imageNamed:@"no-image"];
        [self setNeedsDisplay];
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    __block id weakSelf = self;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeCenter;
    __block __weak UIImageView *weakImageView = imageView;
    NSString *key = [[imageUrl pathComponents] lastObject];
    if ([[EGOCache globalCache] hasCacheForKey:key]) {
        UIImage *image = [[EGOCache globalCache] imageForKey:key];
        [self performSelectorOnMainThread:@selector(loadedImage:) withObject:image waitUntilDone:NO];
    } else {
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakImageView.image = nil;
            weakImageView = nil;
            [weakSelf performSelectorOnMainThread:@selector(loadedImage:) withObject:image waitUntilDone:NO];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            _image = [UIImage imageNamed:@"no-image"];
            [self setNeedsDisplay];
            NSLog(@"%@", error.localizedDescription);
        }];
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)loadedImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

- (void)didTapIcon:(UITapGestureRecognizer *) gesture {
    if ([_delegate respondsToSelector:@selector(didTapAvatarView:)])
        [_delegate didTapAvatarView:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect b = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);

    CGPathRef circlePath = CGPathCreateWithEllipseInRect(b, 0);
    //CGMutablePathRef inverseCirclePath = CGPathCreateMutableCopy(circlePath);
    //CGPathAddRect(inverseCirclePath, nil, CGRectInfinite);

    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
        CGSize sizeBeingScaledTo = CGSizeAspectFill(_image.size, b.size);
        [_image drawInRect:CGRectMake(0, 0, sizeBeingScaledTo.width, sizeBeingScaledTo.height)];
    } CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx); {
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, circlePath);
        CGContextClip(ctx);
        
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3.0f, [UIColor colorWithRed:0.994 green:0.989 blue:1.000 alpha:1.0f].CGColor);
        
        CGContextBeginPath(ctx);
     //   CGContextAddPath(ctx, inverseCirclePath);
        CGContextEOFillPath(ctx);
    } CGContextRestoreGState(ctx);
    
    CGPathRelease(circlePath);
 //   CGPathRelease(inverseCirclePath);
    
    CGContextRestoreGState(ctx);
}

CGSize CGSizeAspectFit(CGSize aspectRatio, CGSize boundingSize)
{
    float mW = boundingSize.width / aspectRatio.width;
    float mH = boundingSize.height / aspectRatio.height;
    if( mH < mW )
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW < mH )
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    return boundingSize;
}

CGSize CGSizeAspectFill(CGSize aspectRatio, CGSize minimumSize)
{
    float mW = minimumSize.width / aspectRatio.width;
    float mH = minimumSize.height / aspectRatio.height;
    if( mH > mW )
        minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW > mH )
        minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
    return minimumSize;
}

- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}




@end
