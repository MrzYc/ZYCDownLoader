//
//  NSString+MD5Str.m
//  ZYCDownLoader
//
//  Created by 赵永闯 on 2017/6/4.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import "NSString+MD5Str.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Str)


- (NSString *)md5 {
    const char *data = self.UTF8String;

    unsigned char md[CC_MD5_DIGEST_LENGTH];

    //把C语言的字符串 --> md5字符串
    CC_MD5(data, (CC_LONG)strlen(data), md);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", md[i]];
    }
    return result;
}

@end
