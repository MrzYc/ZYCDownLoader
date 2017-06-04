//
//  ZYCDownLoadManager.h
//  ZYCDownLoader
//
//  Created by 赵永闯 on 2017/6/4.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYCDownLoader.h"

@interface ZYCDownLoadManager : NSObject


+ (instancetype)shareInstance;

//一个下载器对应一个下载任务
- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType) downLoadInfo progress:(ProgressChangeBlockType)progressBlock success:(SuccessBlockType)successBlcok failed:(FailBlokcType)failedBlcok;


- (void)pauseWithURL:(NSURL *)url;
- (void)resumeWithURL:(NSURL *)url;
- (void)cancelWithURL:(NSURL *)url;


- (void)pauseAll;
- (void)resumeAll;


@end
