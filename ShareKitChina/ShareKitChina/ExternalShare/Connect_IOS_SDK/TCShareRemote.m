//
//  TCShareRemote.m
//  mgushi
//
//  Created by Enkows Zhang on 14-5-14.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "TCShareRemote.h"
#import "ExternalShare.h"
#import "UISystemUtil.h"

@implementation TCShareRemote

- (void)processObject:(ExternalShareObject *)object;
{
    WeiBo_add_pic_t_POST *request = [[WeiBo_add_pic_t_POST alloc] init];
    request.param_content = [NSString stringWithFormat:@"%@ %@", object.title, object.url];
    request.param_pic = object.previewImage;
    
    request.param_compatibleflag = @"0x2|0x4|0x8|0x20";
    
    if(NO == [[[ExternalShare instance] txOauth] sendAPIRequest:request callback:[ExternalShare instance]])
    {
        [UIAlertView showMsg:@"授权无效或者过期"];
    }
}

@end
