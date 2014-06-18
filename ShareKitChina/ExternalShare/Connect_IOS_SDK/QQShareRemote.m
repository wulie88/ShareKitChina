//
//  QQShareRemote.m
//  mgushi
//
//  Created by Leo on 14-5-12.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "QQShareRemote.h"
#import "UISystemUtil.h"

@implementation QQShareRemote

- (void)processObject:(ExternalShareObject *)object
{
    QQApiNewsObject *messge = [[QQApiNewsObject alloc] init];
    messge.url = [NSURL URLWithString:object.url];
    messge.title = object.title;
    messge.description = object.content;
    messge.previewImageData = object.previewImageData;
    messge.previewImageURL = object.previewImageExternalUrl;
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:messge];
    //将内容分享到qq
    if (_scene == QQSceneQZone) {
        [QQApiInterface SendReqToQZone:req];
    } else {
        [QQApiInterface sendReq:req];
    }
}

@end
