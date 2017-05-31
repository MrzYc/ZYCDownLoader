//
//  ZYCFileTool.h
//  ZYCDownLoader
//
//  Created by Circcus on 2017/5/26.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYCFileTool : NSObject

+ (BOOL)fileExists:(NSString *)filePath;

+ (long long)fileSize:(NSString *)filePath;

+ (void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;

+ (void)removeFile:(NSString *)filePath;


@end
