//
//  ViewController.m
//  ZYCDownLoader
//
//  Created by Circcus on 2017/5/26.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import "ViewController.h"
#import "ZYCDownLoader.h"

@interface ViewController ()

@property (nonatomic, strong) ZYCDownLoader *downLoader;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ViewController

- (ZYCDownLoader *)downLoader {
    if (!_downLoader) {
        _downLoader = [ZYCDownLoader new];
    }
    return _downLoader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
}
- (IBAction)download:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/zyw113/ZYWStock/master/resourse/demo3.gif"];
    [self.downLoader downLoader:url];
}

- (IBAction)pause:(id)sender {
    [self.downLoader pauseCurrentTask];
}
- (IBAction)cancel:(id)sender {
    [self.downLoader cancelCurrentTask];
    
}
- (IBAction)cancelAndClear:(id)sender {
    [self.downLoader cancelAndClear];
    
}



@end
