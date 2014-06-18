//
//  WBShareRemote.m
//  mgushi
//
//  Created by Enkows Zhang on 14-5-13.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "WBShareRemote.h"
#import "WeiboSDK.h"
#import "UISystemUtil.h"

@implementation WBShareRemote

- (void)share:(int)scene withObject:(ExternalShareObject*)object
{
    _scene = scene;
    _object = object;
    
    if ([NSString isEmptyOrNull:object.identifiy]) {
        [UIAlertView showMessage:@"不支持分享"];
        return;
    }
    
    [self requestImage:THUMB(object.previewImageInternalUrl)];
}

- (void)processObject:(ExternalShareObject *)object
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = object.previewImageData;
    
    message.text = [NSString stringWithFormat:@"%@ %@ @完美故事官微", object.content, object.url];
    message.imageObject = image;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    
    [WeiboSDK sendRequest:request];
}

@end
