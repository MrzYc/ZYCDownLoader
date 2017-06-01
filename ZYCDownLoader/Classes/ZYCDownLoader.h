//
//  ZYCDownLoader.h
//  ZYCDownLoader
//
//  Created by Circcus on 2017/5/26.
//  Copyright © 2017年 com.circcus. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger , ZYCDownLoadState) {
    ZYCDownLoadStatePause,
    ZYCDownLoadStateDownLoading,
    ZYCDownLoadStatePauseSuccess,
    ZYCDownLoadStatePauseFailed
};

@interface ZYCDownLoader : NSObject

//一个下载器对应一个下载任务
- (void)downLoader:(NSURL *)url;

//暂停当前任务
- (void)pauseCurrentTask;
//取消当前任务
- (void)cancelCurrentTask;
//取消任务,清除缓存
- (void)cancelAndClear;


///数据
/**  */
@property (nonatomic , assign) ZYCDownLoadState state;



@end
