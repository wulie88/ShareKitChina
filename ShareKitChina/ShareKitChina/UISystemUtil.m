//
//  UISystemUtil.m
//  ShareKitChina
//
//  Created by Leo on 14-6-18.
//  Copyright (c) 2014年 cnnetlab. All rights reserved.
//

#import "UISystemUtil.h"

@implementation UIView(UISystemUtil)

/**
 *  系统版本
 *
 *  @return 版本
 */
+ (float)systemVersion;
{
    static dispatch_once_t pred = 0;
    static NSUInteger version = -1;
    dispatch_once(&pred, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

/**
 *  应用版本
 *
 *  @return 版本
 */
+ (NSString*)appVersion;
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

/**
 *  窗口大小
 *
 *  @return CGSize
 */
+ (CGSize)windowSize;
{
    static dispatch_once_t pred = 0;
    static CGSize size;
    dispatch_once(&pred, ^{
        size = [[UIScreen mainScreen] bounds].size;
    });
    return size;
}

/**
 *  带状态栏视图大小信息
 *
 *  @return CGRect
 */
+ (CGRect)frameForStateBar;
{
    float systemVersion = [UIView systemVersion];
    return CGRectMake(0, systemVersion >= 7.0 ? 20.0f : 0.0f, [UIView windowSize].width, systemVersion >= 7.0 ? ([UIView windowSize].height - 20) : [UIView windowSize].height);
}

@end

@implementation UIAlertView (UISystemUtil)

+ (void)showMessage:(NSString *)message;
{
    [UIAlertView showMessage:message cancelTitle:NSLocalizedString(@"OK", @"好")];
}

+ (void)showMessage:(NSString *)message title:(NSString *)title;
{
    [UIAlertView showMessage:message cancelTitle:NSLocalizedString(@"OK", @"好") title:title];
}

+ (void)showMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle;
{
    [UIAlertView showMessage:message cancelTitle:cancelTitle title:nil];
}

+ (void)showMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle title:(NSString *)title;
{
    // 提示信息
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:cancelTitle
                                            otherButtonTitles:nil];
    [alertView show];
}

@end

@implementation NSString (UISystemUtil)

/**
 *  判断字符串是否为空
 *
 *  @param str 字符串
 *
 *  @return 是否为空
 */
+ (Boolean)isEmptyOrNull:(NSString *)str
{
    if (!str || [str isKindOfClass:[NSNull class]]) {
        // null object
        return true;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return true;
        } else {
            // is neither empty nor null
            return false;
        }
    }
}

@end
