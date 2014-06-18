//
//  ExternalShareRemote.m
//  mgushi
//
//  Created by Leo on 14-5-12.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "ExternalShareRemote.h"

#import "WXShareRemote.h"
#import "objc/runtime.h"
#import "UISystemUtil.h"

// 动态属性指针
static char ExternalShareRemoteOperationKey;

@implementation ExternalShareRemote

- (void)share:(int)scene withObject:(ExternalShareObject*)object
{
    _scene = scene;
    _object = object;
    
    if ([NSString isEmptyOrNull:object.identifiy]) {
        [UIAlertView showMessage:@"不支持分享"];
        return;
    }
    
    [self requestImage:THUMBMINI(object.previewImageInternalUrl)];
}

- (void)requestImage:(NSURL*)url;
{
    [self cancel];
    
    if (url)
    {
        [SVProgressHUD showWithStatus:@"准备中..." maskType:SVProgressHUDMaskTypeClear];
        
        __weak ExternalShareRemote *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                                             {
                                                 // 取消提示
                                                 [SVProgressHUD dismiss];
                                                 
                                                 if (!wself) return;
                                                 dispatch_main_sync_safe(^
                                                                         {
                                                                             if (!wself) return;
                                                                             if (image)
                                                                             {
                                                                                 [wself complete:image];
                                                                             }
                                                                         });
                                             }];
        objc_setAssociatedObject(self, &ExternalShareRemoteOperationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)complete:(UIImage*)image
{
    _object.previewImage = image;
    
    [self processObject:_object];
}

- (void)processObject:(ExternalShareObject *)object
{
}

- (void)cancel
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &ExternalShareRemoteOperationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &ExternalShareRemoteOperationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
