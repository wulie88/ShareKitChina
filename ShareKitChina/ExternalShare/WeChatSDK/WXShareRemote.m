//
//  WXShareRemote.m
//  mgushi
//
//  Created by Leo on 14-5-6.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "WXShareRemote.h"
#import "objc/runtime.h"
#import "UISystemUtil.h"
#import "ImageUtil.h"


@implementation WXShareRemote

- (void)share:(int)scene withObject:(ExternalShareObject *)object;
{
    if (![WXApi isWXAppInstalled]) {
        [UIAlertView showMsg:@"没有安装微信"];
        return;
    }
    
    if (![WXApi isWXAppSupportApi]) {
        [UIAlertView showMsg:@"微信不支持分享"];
        return;
    }
    
    // 朋友圈交换
    if (scene == WXSceneTimeline) {
        NSString *title = object.content;
        object.title = object.content;
        object.content = title;
    }
    
    [super share:scene withObject:object];
}

- (void)processObject:(ExternalShareObject *)object
{
    WXWebpageObject *pageObject = [WXWebpageObject object];
    pageObject.webpageUrl = object.url;
    
    WXMediaMessage *message = [[WXMediaMessage alloc] init];
    message.title = object.title;
    message.description = object.content;
    message.thumbData = object.previewImageData;
    message.mediaObject = pageObject;
    
    SendMessageToWXReq *send = [[SendMessageToWXReq alloc] init];
    send.message = message;
    send.bText = NO;
    send.scene = _scene;
    
    [WXApi sendReq:send];
}

@end
