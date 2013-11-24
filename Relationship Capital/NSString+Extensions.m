//
//  NSString+Extensions.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extensions)


- (NSString *)md5 {
    return md5(self);
}

- (NSURL *)emailToGravatarUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://gravatar.com/avatar/%@?s=200", md5(self)]];
}

NSString* md5( NSString *str ) {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (int)strlen(cStr), result );
    
    return [[NSString
             stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1],
             result[2], result[3],
             result[4], result[5],
             result[6], result[7],
             result[8], result[9],
             result[10], result[11],
             result[12], result[13],
             result[14], result[15]
             ] lowercaseString];
}

@end
