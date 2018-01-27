//
//  Hud.h
//  HappySend
//
//  Created by JianRen on 17/4/24.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hud : NSObject

//显示加载中
+(void)showLoading;

//显示正在上传
+(void)showUpload;

//显示文字
+(void)showText:(NSString *)text;
+(void)showText:(NSString *)text withTime:(CGFloat)timeInterval;

//停止显示
+(void)stop;

@end
