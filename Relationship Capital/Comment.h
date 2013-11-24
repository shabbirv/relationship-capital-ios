//
//  Comment.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/23/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) int commitmentId;

@end
