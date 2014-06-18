//
//  ExternalShareObject.h
//  mgushi
//
//  Created by Leo on 14-5-15.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  分享内容统一对象
 */
@interface ExternalShareObject : NSObject

// 唯一标示
@property (nonatomic, copy) NSString *identifiy;

// 名称
@property (nonatomic, copy) NSString *title;

// 分享描述
@property (nonatomic, copy) NSString *content;

// 链接
@property (nonatomic, copy) NSString *url;

// 预览图片
@property (nonatomic, retain) UIImage *previewImage;

// 预览图片内部链接
@property (nonatomic, copy) NSURL *previewImageInternalUrl;

// 预览图片外部链接
@property (nonatomic, copy) NSURL *previewImageExternalUrl;

/**
 *  得到预览图片数据
 *
 *  @return 图片数据
 */
- (NSData*)previewImageData;

@end


@protocol ExternalShareObjectConvert <NSObject>

// 转换成分享对象
- (ExternalShareObject*)externalShareObject;

@end
