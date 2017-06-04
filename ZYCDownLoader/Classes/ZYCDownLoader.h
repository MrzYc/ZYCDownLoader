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


typedef void (^StateChageType) (ZYCDownLoadState state);
typedef void (^DownLoadInfoType) (long long totalSize);
typedef void (^ProgressChangeBlockType) (float progresss);
typedef void (^SuccessBlockType) (NSString *filePath);
typedef void (^FailBlokcType) ();


@interface ZYCDownLoader : NSObject

//一个下载器对应一个下载任务
- (void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType) downLoadInfo progress:(ProgressChangeBlockType)progressBlock success:(SuccessBlockType)successBlcok failed:(FailBlokcType)failedBlcok;

//暂停当前任务
- (void)pauseCurrentTask;
//取消当前任务
- (void)cancelCurrentTask;
//取消任务,清除缓存
- (void)cancelAndClear;

- (void)resumeCurrentTask;


///数据
/**  */
@property (nonatomic , assign, readonly) ZYCDownLoadState state;
/** 进度 */
@property (nonatomic, assign, readonly) float  progress;


/** 事件 */
@property (nonatomic, copy) DownLoadInfoType downLoadInfo;
//状态
@property (nonatomic, copy) StateChageType stateChage;

@property (nonatomic, copy) ProgressChangeBlockType  progressChange;

/** 成功 */
@property (nonatomic, copy) SuccessBlockType successBlock;

/** 失败  */
@property (nonatomic, copy) FailBlokcType failBlcok;



@end
