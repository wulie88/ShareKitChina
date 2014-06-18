//
//  ExternalShareObject.m
//  mgushi
//
//  Created by Leo on 14-5-15.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "ExternalShareObject.h"
#import "ImageUtil.h"

@implementation ExternalShareObject

- (NSData*)previewImageData;
{
    // 压缩图片
    NSData *imageData = UIImageJPEGRepresentation(self.previewImage, 0.8);
    LOG(@"ExternalShareObject share image:%.0fK", imageData.length / 1024.0f);
    
    return imageData;
}

@end
