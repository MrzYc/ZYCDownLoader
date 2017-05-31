//
//  ZYCFileTool.m
//  ZYCDownLoader
//
//  Created by Circcus on 2017/5/26.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import "ZYCFileTool.h"

@implementation ZYCFileTool


+ (BOOL)fileExists:(NSString *)filePath {
    if (filePath.length == 0) {
        return NO;
    }
     return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


+ (long long)fileSize:(NSString *)filePath {
    if (![self fileExists:filePath]) {
        return 0;
    }
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [fileInfo[NSFileSize] longLongValue];
}

//文件移动
+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath {
    if (![self fileSize:fromPath]) {
        return;
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
}


+ (void)removeFile:(NSString *)filePath {
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
