//
//  Hud.m
//  HappySend
//
//  Created by JianRen on 17/4/24.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "Hud.h"

@implementation Hud

+(void)showLoading
{

    UIView *view = [self getView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在加载";
    hud.label.font = [UIFont systemFontOfSize:15];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:20];

}

+(void)showUpload
{

    UIView *view = [self getView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在上传";
    hud.label.font = [UIFont systemFontOfSize:15];
    [hud showAnimated:YES];
    
}

+(void)showText:(NSString *)text
{
    if(![text isEqualToString:@"null"])
    {
        UIView *view = [self getView];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.label.font = [UIFont systemFontOfSize:15];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];
    }

}

+(void)showText:(NSString *)text withTime:(CGFloat)timeInterval
{

    UIView *view = [self getView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:15];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.5];
    
}

+(void)stop
{

    UIView *view = [self getView];
    [MBProgressHUD hideHUDForView:view animated:YES];

}

+(UIWindow *)getView
{
    UIWindow *mainWindow = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
//        mainWindow = [[UIApplication sharedApplication].windows firstObject];
//    } else {
//        mainWindow = [[UIApplication sharedApplication].windows lastObject];
//    }

    mainWindow = [[UIApplication sharedApplication].windows lastObject];

    return mainWindow;
    
    
    

    
}


@end
