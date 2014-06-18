//
//  ExternalShareObject.m
//  mgushi
//
//  Created by Leo on 14-5-15.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "ExternalShareObject.h"

@implementation ExternalShareObject

- (NSData*)previewImageData;
{
    // 压缩图片
    NSData *imageData = UIImageJPEGRepresentation(self.previewImage, 0.8);
    
    return imageData;
}

@end
