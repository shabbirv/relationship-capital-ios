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

- (void)signupWithDict:(NSDictionary *)dict completion:(void (^)(NSDictionary *, NSError *))completionBlock {
    AFHTTPClient *client = [CapitalEngine client];
    [client postPath:@"/api/v1/user" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = responseObject;
        User *user = [User currentUser];
        user.authToken = resultDict[@"auth_token"];
        user.email = resultDict[@"current_user_email"];
        NSLog(@"%@", resultDict);
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

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(ConditionalBlock)block {
    NSDictionary *parameters = @{
                                 @"email" : email,
                                 @"password" : password
                                 };
    AFHTTPClient *client = [CapitalEngine client];
    [client postPath:@"/api/v1/user/sign_in" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = responseObject;
        User *user = [User currentUser];
        NSLog(@"%@", resultDict);
        if ([[resultDict objectForKey:@"auth_token"] length] == 0) {
            if (block) block(NO);
        } else {
            user.authToken = resultDict[@"auth_token"];
            user.email = resultDict[@"current_user_email"];
            user.dashboardAPIUrl = resultDict[@"link_to_user_dashboard"];
            if (block) block(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
    }];
}

- (void)getDashboardForUser:(User *)user completion:(ResultBlock)block {
    AFHTTPClient *client = [CapitalEngine client];
    [client getPath:user.dashboardAPIUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userDict = responseObject[@"user"];
        user.firstName = userDict[@"first_name"];
        user.userId = [userDict[@"id"] intValue];
        user.username = userDict[@"user_name"];
        user.rcScore = [userDict[@"r_c_score"] intValue];
        user.lastName = userDict[@"last_name"];
        
        //Gather friends of the User
        NSMutableArray *friends = [NSMutableArray array];
        for (NSDictionary *fShipDict in userDict[@"friendships"]) {
            NSDictionary *friendshipDict = fShipDict[@"friendship"];
            NSDictionary *friendDict = friendshipDict[@"friend"];
            Friend *friend = [[Friend alloc] init];
            friend.friendStatus = [friendshipDict[@"friendship_status"] intValue];
            friend.email = friendDict[@"friend_email"];
            friend.firstName = friendDict[@"friend_first_name"];
            friend.lastName = friendDict[@"friend_last_name"];
            friend.userId = [friendDict[@"friend_id"] intValue];
            friend.username = friendDict[@"friend_user_name"];
            friend.friendshipId = [friendshipDict[@"id"] intValue];
            friend.dashboardAPIUrl = [NSString stringWithFormat:@"/api/v1/users/%d", friend.userId];
            [friends addObject:friend];
        }
        user.friends = [NSArray arrayWithArray:friends];

        //Gather the commitments for the User
        NSMutableArray *commitments = [NSMutableArray array];
        for (NSDictionary *cDict in userDict[@"commitments"]) {
            NSDictionary *commitmentDict = cDict[@"commitment"];
            Commitment *commitment = [[Commitment alloc] init];
            SET_IF_NOT_NULL(commitment.commitmentDescription, commitmentDict[@"description"]);
            commitment.issuerId = [commitmentDict[@"issuer_id"] intValue];
            SET_IF_NOT_NULL(commitment.name, commitmentDict[@"name"]) ;
            commitment.status = [commitmentDict[@"status"] intValue];
            if ([commitmentDict[@"reciever_id"] isEqual:[NSNull null]])
                continue;
            commitment.receiverId = [commitmentDict[@"reciever_id"] intValue];
            commitment.commitmentId = [commitmentDict[@"id"] intValue];
            commitment.difficulty = ([commitmentDict[@"difficulty_score"] isEqual:[NSNull null]]) ? DifficultyLevelEasy : [commitmentDict[@"difficulty_score"] intValue];
            [commitments addObject:commitment];
        }
        user.commitments = [NSArray arrayWithArray:commitments];
        
        //Gather requests
        //Gather the commitments for the User
        NSMutableArray *requests = [NSMutableArray array];
        for (NSDictionary *rDict in userDict[@"requests"]) {
            NSDictionary *requestDict = rDict[@"request"];
            Request *request = [[Request alloc] init];
            SET_IF_NOT_NULL(request.commitmentDescription, requestDict[@"description"]);
            request.issuerId = [requestDict[@"issuer_id"] intValue];
            SET_IF_NOT_NULL(request.name, requestDict[@"name"]) ;
            request.status = [requestDict[@"status"] intValue];
            if ([requestDict[@"reciever_id"] isEqual:[NSNull null]])
                continue;
            request.receiverId = [requestDict[@"reciever_id"] intValue];
            request.difficulty = ([requestDict[@"difficulty_score"] isEqual:[NSNull null]]) ? DifficultyLevelEasy : [requestDict[@"difficulty_score"] intValue];
            request.commitmentId = [requestDict[@"id"] intValue];
            [requests addObject:request];
        }
        user.requests = [NSArray arrayWithArray:requests];
        
        if (block) {
            block(responseObject, nil);
        }
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
    }];
}

- (void)respondToFriendRequestWithId:(int)friendshipId shouldAccept:(BOOL)accept completion:(Completion)block {
    NSDictionary *parameters = @{
                                 @"authentication_token" : [User currentUser].authToken
                                 };
    AFHTTPClient *client = [CapitalEngine client];
    NSString *path = [NSString stringWithFormat:@"/api/v1/friendships/%d", friendshipId];
    if (accept) {
        [client putPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) { block();}
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
        }];
    } else {
        [client deletePath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) { block();}
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
        }];
    }
}

- (void)respondToCommitment:(Commitment *)commitment shouldAccept:(BOOL)accept completion:(Completion)block {
    NSDictionary *parameters = @{
                                 @"authentication_token" : [User currentUser].authToken
                                 };
    AFHTTPClient *client = [CapitalEngine client];
    NSString *path = [NSString stringWithFormat:@"/api/v1/commitments/%d", commitment.commitmentId];
    if (accept) {
        [client putPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            if (block) { block();}
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
        }];
    } else {
        [client deletePath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            if (block) { block();}
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
        }];
    }
}

- (void)loadUsersWithCompletion:(ResultBlock)block {
    AFHTTPClient *client = [CapitalEngine client];
    [client getPath:@"/api/v1/users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *uDict in responseObject[@"users"]) {
            NSDictionary *userDict = uDict[@"user"];
            User *user = [[User alloc] init];
            SET_IF_NOT_NULL(user.firstName, userDict[@"first_name"]);
            SET_IF_NOT_NULL(user.lastName, userDict[@"last_name"]);
            SET_IF_NOT_NULL(user.username, userDict[@"user_name"]);
            SET_IF_NOT_NULL(user.email, userDict[@"email"]);
            user.userId = [userDict[@"id"] intValue];
            user.rcScore = [userDict[@"r_c_score"] intValue];
            [array addObject:user];
        }
        
        if (block) {
            block(array, nil);
        }
        
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)addCommitment:(NSDictionary *)commitmentDict completion:(Completion)block {
    AFHTTPClient *client = [CapitalEngine client];
    [client postPath:@"/api/v1/commitments" parameters:commitmentDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if (block) {
            block();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
    }];
}

- (void)addComment:(NSString *)comment forCommitment:(Commitment *)commitment completion:(Completion)completion {
    NSDictionary *dict = @{@"text": comment,
                           @"user_id" : @([User currentUser].userId),
                           @"commitment_id" : @(commitment.commitmentId)};
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://shabz.co"]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client postPath:@"/api/rc/addcomment.php" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if (completion) {
            completion();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail: %@\n%@", operation.responseString, error.localizedDescription);
    }];
}

- (void)getCommentsForCommitment:(Commitment *)commitment completion:(ResultBlock)block {
    NSDictionary *dict = @{@"commitment_id": @(commitment.commitmentId)};
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://shabz.co"]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client getPath:@"/api/rc/getcomments.php" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObject) {
            Comment *comment = [[Comment alloc] init];
            comment.commitmentId = [dict[@"commitment_id"] intValue];
            comment.text = dict[@"text"];
            comment.user = [[User alloc] init];
            comment.user.email = dict[@"user"][@"email"];
            comment.user.userId = [dict[@"user"][@"id"] intValue];
            comment.user.firstName = [[dict[@"user"][@"name"] componentsSeparatedByString:@" "] firstObject];
            comment.user.lastName = [[dict[@"user"][@"name"] componentsSeparatedByString:@" "] lastObject];
            [array addObject:comment];
        }
        if (block) {
            block(array, nil);
        }
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
