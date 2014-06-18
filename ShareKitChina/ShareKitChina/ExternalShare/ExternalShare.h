//
//  ExternalShare.h
//  mgushi
//
//  Created by Leo on 14-5-12.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>

typedef NS_ENUM(NSInteger, ExternalShareType) {
    ExternalShareTypeWeixin,
    ExternalShareTypeWeixinGroup,
    ExternalShareTypeQQ,
    ExternalShareTypeQZone,
    ExternalShareTypeWeibo,
    ExternalShareTypeTWeibo,
};

@interface ExternalShare : NSObject <TCAPIRequestDelegate>

/**
 *  单例
 */
+ (ExternalShare*)instance;

/**
 *  处理外部链接
 *
 *  @param url 链接
 *
 *  @return 是否处理
 */
- (BOOL)handleAppUrl:(NSURL*)url;

/**
 *  分享
 *
 *  @param shareType 类型
 *  @param object    内容
 */
- (void)shareType:(ExternalShareType)shareType withObject:(id<ExternalShareObjectConvert>)object;

@property (nonatomic, retain) TencentOAuth *txOauth;

@end
