//
//  CapitalEngine.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/3/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "User.h"

@interface CapitalEngine : NSObject

+ (CapitalEngine *)sharedEngine;

- (void)signupWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *dict, NSError *error))completionBlock;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL success))completionBlock;
@end
