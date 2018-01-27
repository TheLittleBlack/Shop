//
//  MyNetworkRequest.h
//  测试工程(使用时另拷贝一份)
//
//  Created by JianRen on 17/3/24.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^dataBlock)(id result);
typedef void(^errorBlock)(id error);

@interface MyNetworkRequest : NSObject



// post请求
+(void)postRequestWithUrl:(NSString *)urlString withPrameters:(NSDictionary *)dictionary result:(dataBlock)block error:(errorBlock)errorBlock withHUD:(BOOL)HUD;

//检测网络连接状态
+(void)networkType:(dataBlock)block;

@end
