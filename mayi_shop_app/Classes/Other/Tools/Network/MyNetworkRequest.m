//
//  MyNetworkRequest.m
//  测试工程(使用时另拷贝一份)
//
//  Created by JianRen on 17/3/24.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "MyNetworkRequest.h"
#import "NSDictionary+GetSign.h"

@implementation MyNetworkRequest




+(void)postRequestWithUrl:(NSString *)urlString withPrameters:(NSDictionary *)dictionary result:(dataBlock)block error:(errorBlock)errorBlock withHUD:(BOOL)HUD
{
    
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    
    
    
    if(HUD)
    {
        [Hud showLoading];
    }
    
    //转为可变字典
    NSMutableDictionary *mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    //如果User-Agent有值
    NSString *userAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"User-Agent"];
    
    
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlString]];
//    NSString *cookieString = @"";
//
//    for (int i = 0; i<cookies.count; i++) {
//
//        NSHTTPCookie *cookie = cookies[i];
//        MyLog(@"%@",cookie);
//        if( [cookie.name isEqualToString:@"MAYI_SHOP_COOKIE_ID"])
//        {
//            cookieString = cookie.value;
//        }
//
//    }
//    MyLog(@"-------------------%@------------------",cookieString);

    if(userAgent)
    {
        // 添加请求头

        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
//        [manager.requestSerializer setValue:cookieString forHTTPHeaderField:@"Cookie"];

    }
    
    // 通过抓包发现并没有加这个东西？
//    [mDictionary setValue:cookieValue forKey:@"MAYI_POS_GUIDE_API_SID"];
    
    NSString *code = [mDictionary getSignString];
    
    [mDictionary setValue:code forKey:@"code"];

    MyLog(@"完整参数:%@",mDictionary);
    
    
    
    [manager POST:urlString parameters:mDictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(HUD)
        {
            [Hud stop];
        }
        
        NSData *data = responseObject;
        NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        MyLog(@"%@",dic);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",dic[@"stateCode"]];
        
        
        
        //登录过期
        if([stateCode isEqualToString:@"300"] || [stateCode isEqualToString:@"401"])
        {

//            UIViewController *currentVC = [self getCurrentVC];
//            LoginViewController *LVC = [LoginViewController new];
//            [currentVC presentViewController:LVC animated:YES completion:^{
//
                [Hud showText:@"登录信息过期，请重新登录" withTime:2];
//
//            }];
//
//            return ;
        }
        
        if(![stateCode isEqualToString:@"200"]&&![stateCode isEqualToString:@"100"])
        {
            [Hud showText:dic[@"message"]];
            return;
        }
        
        block(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
        
        if(HUD)
        {
            [Hud stop];
        }
        
        [Hud showText:@"网络错误" withTime:1.5];
        
        MyLog(@"erroe = %@",error);
        
        errorBlock(error);
        
    }];
}







//检测网络类型
+(void)networkType:(dataBlock)block
{
    __block NSString *Type = @"";
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
            {
                Type = @"未知网络类型";
            }
            break;
            case 0:
            {
                Type = @"未连接到网络";
            }
            break;
            case 1:
            {
                Type = @"非Wifi环境";
            }
            break;
            default:
            {
                Type = @"Wifi已连接";
            }
            break;
        }
        block(Type);
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
    
}



@end
