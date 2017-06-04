//
//  ZYCDownLoadManager.m
//  ZYCDownLoader
//
//  Created by 赵永闯 on 2017/6/4.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import "ZYCDownLoadManager.h"
#import "NSString+MD5Str.h"

@interface ZYCDownLoadManager () <NSCopying, NSMutableCopying>

/** 下载 */
//@property (nonatomic, strong) ZYCDownLoader *downLoader;

/** 下载信息 */
@property (nonatomic, strong) NSMutableDictionary *downLoadInfo;


@end

@implementation ZYCDownLoadManager

static ZYCDownLoadManager *_shareInstance;

+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

-(id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}



- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}


//key:md5(url) value:ZYCDownload
- (NSMutableDictionary *)downLoadInfo {
    if (!_downLoadInfo) {
        _downLoadInfo = [NSMutableDictionary dictionary];
    }
    return _downLoadInfo;
}

//一个下载器对应一个下载任务
- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType) downLoadInfo progress:(ProgressChangeBlockType)progressBlock success:(SuccessBlockType)successBlcok failed:(FailBlokcType)failedBlcok {
    
    //1.url
    NSString *urlMD5 = [url.absoluteString md5];
    //2.根据urlMD5,查找相应的下载器
    ZYCDownLoader *downLoader = self.downLoadInfo[urlMD5];
    if (downLoader == nil) {
        downLoader = [[ZYCDownLoader alloc] init];
        self.downLoadInfo[urlMD5] = downLoader;
    }
    
//    [downLoader downLoader:url downLoadInfo:downLoadInfo progress:progressBlock success:successBlcok failed:failedBlcok];
    
    __weak typeof(self) weakSelf = self;
    [downLoader downLoader:url downLoadInfo:downLoadInfo progress:progressBlock success:^(NSString *filePath) {
        //拦截block
        [weakSelf.downLoadInfo removeObjectForKey:url];
        successBlcok(filePath);
    } failed:failedBlcok];
}


- (void)pauseWithURL:(NSURL *)url {
    
    NSString *urlMD5 = [url.absoluteString md5];
    ZYCDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader pauseCurrentTask];
}

- (void)resumeWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    ZYCDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader resumeCurrentTask];
}
- (void)cancelWithURL:(NSURL *)url {
    NSString *urlMD5 = [url.absoluteString md5];
    ZYCDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader cancelCurrentTask];
}

- (void)pauseAll {
    
    [self.downLoadInfo.allValues performSelector:@selector(pauseCurrentTask) withObject:nil];
}
- (void)resumeAll {
    [self.downLoadInfo.allValues performSelector:@selector(resumeCurrentTask) withObject:nil];
}

@end
