//
//  CapitalEngine.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/3/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "CapitalEngine.h"

@implementation CapitalEngine


+ (CapitalEngine *)sharedEngine {
    static CapitalEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedEngine == nil) {
            sharedEngine = [[self alloc] init];
        }
    });
    return sharedEngine;
}

+ (AFHTTPClient *) client {
    static AFHTTPClient *client = nil;
	
	@synchronized(self)
	{
		if (client == nil)
		{
			client = [[AFHTTPClient alloc] initWithBaseURL:BASE_URL];
            [client setDefaultHeader:@"Accept" value:@"application/json"];
            [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
		}
	}
	return client;
}

- (void)signupWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *dict, NSError *error))completionBlock {
    NSDictionary *parameters = @{
                                 @"email" : email,
                                 @"password" : password,
                                 @"password_confirmation" : password
                                 };
    AFHTTPClient *client = [CapitalEngine client];
    [client postPath:@"/api/v1/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = responseObject;
        User *user = [User currentUser];
        user.authToken = resultDict[@"auth_token"];
        user.email = resultDict[@"current_user_email"];
        if (completionBlock) {
            completionBlock(resultDict, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            if (dict) {
                completionBlock(dict, error);
            }
        }
        NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
    }];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL success))completionBlock {
    NSDictionary *parameters = @{
                                 @"email" : email,
                                 @"password" : password
                                 };
    AFHTTPClient *client = [CapitalEngine client];
    [client postPath:@"/api/v1/user/sign_in" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = responseObject;
        User *user = [User currentUser];
        if ([[resultDict objectForKey:@"auth_token"] length] == 0) {
            if (completionBlock) completionBlock(NO);
        } else {
            user.authToken = resultDict[@"auth_token"];
            user.email = resultDict[@"current_user_email"];
            user.dashboardAPIUrl = resultDict[@"link_to_user_dashboard"];
            if (completionBlock) completionBlock(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
    }];
}

@end
