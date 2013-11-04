//
//  AvatarView.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//


#import <UIKit/UIKit.h>

@class AvatarView;

@protocol AvatarViewDelegate <NSObject>
@optional
- (void)didTapAvatarView:(AvatarView *)avatarView;
@end

@interface AvatarView : UIButton  {

}

@property (strong, nonatomic) UIImage *image;
@property (nonatomic, assign) NSURL *imageUrl;
@property (nonatomic, weak) id<AvatarViewDelegate> delegate;
@property (nonatomic, assign) BOOL showShadow;

@end
