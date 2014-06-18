//
//  QQShareRemote.h
//  mgushi
//
//  Created by Leo on 14-5-12.
//  Copyright (c) 2014年 1stcore. All rights reserved.
//

#import "ExternalShareRemote.h"
#import <TencentOpenAPI/QQApiInterface.h>

/*! @brief 请求发送场景
 *
 */
enum QQScene {
    
    QQSceneSession  = 0,        /**< 聊天界面    */
    QQSceneQZone = 1,        /**< QQ空间      */
};

@interface QQShareRemote : ExternalShareRemote

@end
