//
//  ExternalShareRemote.h
//  mgushi
//
//  Created by Leo on 14-5-12.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExternalShareObject.h"

/**
 *  远程分享
 *  用于需要获得远程图片后分享
 */
@interface ExternalShareRemote : NSObject
{
    int _scene;
    ExternalShareObject *_object;
}

/**
 *  1 准备媒体信息[需要继承]
 *
 *  @return 媒体信息
 */
- (void)processObject:(ExternalShareObject*)object;

/**
 *  分享
 */
- (void)share:(int)scene withObject:(ExternalShareObject*)object;

/**
 *  取消
 */
- (void)cancel;

/**
 *  请求
 *
 *  @param url 地址
 */
- (void)requestImage:(NSURL*)url;

@end
