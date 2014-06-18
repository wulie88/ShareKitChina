//
//  ExternalShare.m
//  mgushi
//
//  Created by Leo on 14-5-12.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "ExternalShare.h"
#import "UISystemUtil.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import "WeiboSDK.h"
#import "WXApiObject.h"
#import "WXShareRemote.h"
#import "WBShareRemote.h"
#import "QQShareRemote.h"
#import "TCShareRemote.h"

@interface ExternalShare () <WXApiDelegate, TencentSessionDelegate, QQApiInterfaceDelegate>
{
    
    // 异步处理要保存对象
    WXShareRemote *_wxShare;
    WBShareRemote *_wbShare;
    QQShareRemote *_qqShare;
    TCShareRemote *_tcShare;
    
    // 腾讯微博分享内容
    id<ExternalShareObjectConvert> _tcObject;
}

@end

@implementation ExternalShare

+ (ExternalShare*)instance;
{
    static dispatch_once_t pred = 0;
    static ExternalShare *externalShare = nil;
    dispatch_once(&pred, ^{
        externalShare = [[ExternalShare alloc] init];
    });
    
    return externalShare;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self registers];
    }
    
    return self;
}

- (void)registers
{
    // 注册微信
    [WXApi registerApp:@"wxec4f962e510385cb"];
    
    self.txOauth = [[TencentOAuth alloc] initWithAppId:@"1101346023" andDelegate:self];
    [self restoreTXOauth];
    
    // 注册微博
#ifdef DEBUG
    [WeiboSDK enableDebugMode:YES];
#endif
    [WeiboSDK registerApp:@"381705558"];
}

- (void)backupTXOauth
{
    [[NSUserDefaults standardUserDefaults] setObject:self.txOauth.accessToken forKey:@"txOauth.accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:self.txOauth.expirationDate forKey:@"txOauth.expirationDate"];
    [[NSUserDefaults standardUserDefaults] setObject:self.txOauth.openId forKey:@"txOauth.openId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)restoreTXOauth
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"txOauth.accessToken"];
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"txOauth.expirationDate"];
    NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:@"txOauth.openId"];
    if (expirationDate && [expirationDate isKindOfClass:[NSDate class]]) {
        self.txOauth.accessToken = accessToken;
        self.txOauth.expirationDate = expirationDate;
        self.txOauth.openId = openId;
    }
}

- (BOOL)handleAppUrl:(NSURL *)url
{
    
    // 微信处理
    [WXApi handleOpenURL:url delegate:self];
    
    [QQApiInterface handleOpenURL:url delegate:self];
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return YES;
}

- (void)shareType:(ExternalShareType)shareType withObject:(id<ExternalShareObjectConvert>)object;
{
    if (shareType == ExternalShareTypeWeibo) {
        int scene = 0;
        
        _wbShare = [[WBShareRemote alloc] init];
        [_wbShare share:scene withObject:[object externalShareObject]];
    } else if (shareType == ExternalShareTypeWeixin || shareType == ExternalShareTypeWeixinGroup) {
        int scene = shareType == ExternalShareTypeWeixin ? WXSceneSession : WXSceneTimeline;
        
        _wxShare = [[WXShareRemote alloc] init];
        [_wxShare share:scene withObject:[object externalShareObject]];
    } else if (shareType == ExternalShareTypeQQ || shareType == ExternalShareTypeQZone) {
        int scene = shareType == ExternalShareTypeQQ ? QQSceneSession : QQSceneQZone;
        
        _qqShare = [[QQShareRemote alloc] init];
        [_qqShare share:scene withObject:[object externalShareObject]];
    } else if (shareType == ExternalShareTypeTWeibo) {
        _tcObject = object;
        
        if (![TencentOAuth iphoneQQInstalled] || ![TencentOAuth iphoneQQSupportSSOLogin]) {
            [UIAlertView showMsg:@"没有安装手机QQ或者手机QQ不支持第三方授权"];
            return;
        }
        
        TencentOAuth *oauth = self.txOauth;
        if (![oauth isSessionValid]) {
            NSArray *permissions = [NSArray arrayWithObjects:@"all", nil];
            [oauth authorize:permissions inSafari:NO];
        } else {
            [self processTCShare];
        }
    }
}

- (void)processTCShare
{
    if (!_tcObject) {
        return;
    }
    
    _tcShare = [[TCShareRemote alloc] init];
    [_tcShare share:0 withObject:[_tcObject externalShareObject]];
    
    _tcObject = nil;
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void)onReq:(BaseReq*)req;
{
    LOG(@"onReq:%@",req);
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void)onResp:(BaseResp*)resp;
{
    LOG(@"onResp:%@",resp);
}

- (void)isOnlineResponse:(NSDictionary *)response;
{
}

#pragma mark - TencentLoginDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin;
{
    [self backupTXOauth];
    
    [self processTCShare];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled;
{
    LOG(@"tencentDidNotLogin");
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork;
{}

#pragma mark - TCAPIRequestDelegate
/**
 *  分享后回调
 *
 *  @param request
 *  @param response
 */
- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response;
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
    {
        
        [UIAlertView showMsg:@"分享成功"];
    } else {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        [UIAlertView showMsg:errMsg title:@"分享失败"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
