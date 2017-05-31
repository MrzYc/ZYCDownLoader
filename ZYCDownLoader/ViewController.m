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



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/zyw113/ZYWStock/master/resourse/demo3.gif"];
    [self.downLoader downLoader:url];
}


@end
