//
//  ViewController.m
//  ZYCDownLoader
//
//  Created by Circcus on 2017/5/26.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import "ViewController.h"
//#import "ZYCDownLoader.h"
#import "ZYCDownLoadManager.h"

@interface ViewController ()

//@property (nonatomic, strong) ZYCDownLoader *downLoader;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
}

- (IBAction)download:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/zyw113/ZYWStock/master/resourse/demo3.gif"];
    
    [[ZYCDownLoadManager shareInstance] downLoader:url downLoadInfo:^(long long totalSize) {
        NSLog(@"下载信息--%lld", totalSize);
    } progress:^(float progresss) {
        NSLog(@"下载进度--%f", progresss);
    } success:^(NSString *filePath) {
        NSLog(@"下载成功--路径:%@", filePath);
    } failed:^{
        NSLog(@"下载失败了");
    }];
    
    
    NSURL *url2 = [NSURL URLWithString:@"https://raw.githubusercontent.com/zyw113/ZYWStock/master/resourse/demo2.gif"];
    
    [[ZYCDownLoadManager shareInstance] downLoader:url2 downLoadInfo:^(long long totalSize) {
        NSLog(@"下载信息--%lld", totalSize);
    } progress:^(float progresss) {
        NSLog(@"下载进度--%f", progresss);
    } success:^(NSString *filePath) {
        NSLog(@"下载成功--路径:%@", filePath);
    } failed:^{
        NSLog(@"下载失败了");
    }];
    
//    [self.downLoader downLoader:url downLoadInfo:^(long long totalSize) {
//        NSLog(@"下载信息--%lld", totalSize);
//    } progress:^(float progresss) {
//        NSLog(@"下载进度--%f", progresss);
//    } success:^(NSString *filePath) {
//        NSLog(@"下载成功--路径:%@", filePath);
//
//    } failed:^{
//        NSLog(@"下载失败了");
//    }];
//
//    [self.downLoader setStateChage:^(ZYCDownLoadState state){
//        NSLog(@"---%zd", state);
//
//    }];
    
//    [self.downLoader downLoader:url];
}

- (IBAction)pause:(id)sender {
//    [self.downLoader pauseCurrentTask];
}
- (IBAction)cancel:(id)sender {
//    [self.downLoader cancelCurrentTask];
    
}
- (IBAction)cancelAndClear:(id)sender {
//    [self.downLoader cancelAndClear];
    
}



@end
