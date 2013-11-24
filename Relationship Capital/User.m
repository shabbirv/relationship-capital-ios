//
//  User.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/3/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)currentUser {
    static User *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (user == nil) {
            user = [[self alloc] init];
        }
    });
    return user;
}

- (BOOL)isLoggedIn {
    if (self.authToken.length > 0) {
        return YES;
    }
    return NO;
}

@end
