//
//  ZYCDownLoader.m
//  ZYCDownLoader
//
//  Created by Circcus on 2017/5/26.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import "ZYCDownLoader.h"
#import "ZYCFileTool.h"

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath NSTemporaryDirectory()

@interface ZYCDownLoader () <NSURLSessionDataDelegate>
{
    long long _tmpSize;
    long long _totalSize;
}


@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSString *downLoadedPath;
@property (nonatomic, copy) NSString *downLoadingPath;
@property (nonatomic, strong) NSOutputStream *outputStream;
/** 下载任务 */
@property (nonatomic , weak) NSURLSessionDataTask *dataTask;

@end


@implementation ZYCDownLoader

- (NSURLSession *)session {
    if (!_session) {
      NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
      _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


//暂停
//调用了几次继续,就要调用几次暂停,才可以继续

- (void)pauseCurrentTask {
    if (self.state == ZYCDownLoadStateDownLoading) {
        self.state = ZYCDownLoadStatePause;
        [self.dataTask suspend];
    }
}

//取消
- (void)cancelCurrentTask {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)cancelAndClear {
    self.state = ZYCDownLoadStatePause;
    [self cancelCurrentTask];
    [ZYCFileTool removeFile:self.downLoadingPath];
    //下载完成的文件 1.手动删除某个文件  2.清理缓存的时候
    
}


//继续动作
//调用了几次暂停,就要调用几次继续,才可以继续
- (void)resumeCurrentTask {
    if (self.dataTask && self.state == ZYCDownLoadStatePause) {
        [self.dataTask resume];
        self.state = ZYCDownLoadStateDownLoading;
    }
}

- (void)downLoader:(NSURL *)url {
    
    //1.从头开始下载
    //2.任务存在继续下载
    
    
    //判断当前的状态,如果是暂停状态可以继续
    if ([url isEqual:self.dataTask.originalRequest.URL]) {
        //判断是否是当前的状态
        [self resumeCurrentTask];
    
        
        return;
    }
    
    
    NSString *fileName = url.lastPathComponent;
    self.downLoadedPath = [kCachePath stringByAppendingPathComponent:fileName];
    self.downLoadingPath = [kTmpPath stringByAppendingPathComponent:fileName];
    

    if ([ZYCFileTool fileExists:self.downLoadedPath]) {
        //下载文件已经存在
        NSLog(@"文件下载完成");
        self.state = ZYCDownLoadStatePauseSuccess;
        return;
    }
    
    if (![ZYCFileTool fileExists:self.downLoadingPath]) {
        //文件不存在,0字节 下载
        [self downLoadWithURL:url offset:0];
        return;
    }
    //文件存在,获取文件当前大小
    _tmpSize = [ZYCFileTool fileSize:self.downLoadingPath];
    [self downLoadWithURL:url offset:_tmpSize];
    
}




#pragma mark ---  NSURLSessionDataDelegate

//第一次接受相应的时候相应调用（响应头，并没有具体的资源内容）
//通过这方法里面系统的会掉代码块，可以控制，是否继续请求，还是取消本次请求
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    //总大小
    NSLog(@"%@", response);
    
    
    // 取资源总大小
    // 1. 从  Content-Length 取出来
    // 2. 如果 Content-Range 有, 应该从Content-Range里面获取
    _totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
       _totalSize =  [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    if (_tmpSize == _totalSize) {
        //1.移动到下载文件夹
        NSLog(@"移动文件到下载文件夹");
        [ZYCFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        //2.取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        //修改状态
        self.state = ZYCDownLoadStatePauseSuccess;
        return;
    }
    
    if (_tmpSize > _totalSize) {
        //1. 删除临时缓存
        NSLog(@"删除临时缓存");
        [ZYCFileTool removeFile:self.downLoadingPath];
        //2.取消请求
        completionHandler(NSURLSessionResponseCancel);
        //3.从0开始下载
        NSLog(@"重新开始下载");
        [self downLoader:response.URL];
     
        return;
    }
    //继续接收数据
    //确定开始下载数据
    self.state = ZYCDownLoadStateDownLoading;
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downLoadingPath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}

//当用户确定继续接受数据的时候
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.outputStream write:data.bytes maxLength:data.length];
    NSLog(@"接收后续数据");
}

// 请求完成的时候调用(请求成功/失败)
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"请求完成");
    if (error == nil) {
        //不一定成功。
        [ZYCFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        self.state = ZYCDownLoadStatePauseSuccess;
    }else {
        NSLog(@"error -- %zd----%@", error.code, error.localizedDescription);
        //取消, 断网
        if (error.code == -999) {
            self.state = ZYCDownLoadStatePause;
        }else {
            self.state = ZYCDownLoadStatePauseFailed;
        }
    }
    
    [self.outputStream close];

}

#pragma mark --- Private methods
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    //session 分配的task默认是任务挂起的状态
    self.dataTask = [self.session dataTaskWithRequest:request];
    [self resumeCurrentTask];
}

#pragma mark -- 事件/数据   
- (void)setState:(ZYCDownLoadState)state {
    if (_state == state) {
        return;
    }
    _state = state;
}



@end
