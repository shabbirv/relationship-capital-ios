//
//  User.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/3/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)currentUser;

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *dashboardAPIUrl;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *commitments;
@property (nonatomic, strong) NSArray *requests;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int rcScore;
@property (nonatomic, assign) BOOL isLoggedIn;


- (void)logoutUser;

@end
