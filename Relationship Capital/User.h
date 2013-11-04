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
@property (nonatomic, strong) NSString *dashboardAPIUrl;
@property (nonatomic, assign) BOOL isLoggedIn;

@end
