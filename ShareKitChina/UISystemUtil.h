//
//  UISystemUtil.h
//  ShareKitChina
//
//  Created by Leo on 14-6-18.
//  Copyright (c) 2014年 cnnetlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UISystemUtil)
/**
 *  系统版本
 *
 *  @return 版本
 */
+ (float)systemVersion;

/**
 *  应用版本
 *
 *  @return 版本
 */
+ (NSString*)appVersion;
/**
 *  窗口大小
 *
 *  @return CGSize
 */
+ (CGSize)windowSize;

/**
 *  带状态栏视图大小信息
 *
 *  @return CGRect
 */
+ (CGRect)frameForStateBar;

@end

@interface UIAlertView (UISystemUtil)

/**
 *  显示信息
 *
 */
+ (void)showMessage:(NSString*)title;

@end

@interface NSString (UISystemUtil)

/**
 *  判断字符串是否为空
 *
 *  @param str 字符串
 *
 *  @return 是否为空
 */
+ (Boolean)isEmptyOrNull:(NSString *)str;

@end