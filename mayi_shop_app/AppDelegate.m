//
//  AppDelegate.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/1/24.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "CartViewController.h"
#import "MineViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "BaseViewController.h"
#import "MYManage.h"

@interface AppDelegate ()<WXApiDelegate>

@property(nonatomic,strong)UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 向微信终端程序注册第三方应用
    [WXApi registerApp:WXAPPID];
    
    // 获取当前版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *UserAgentString = [NSString stringWithFormat:@"{\"systemType\":\"iOS\",\"appVersion\":\"%@\",\"model\":\"model\",\"systemVersion\":\"%@\"}",appCurVersion,phoneVersion];
    MyLog(@"%@",UserAgentString);
    
    // 设置自定义 UserAgent 用于区分app调用H5  WebView会自动从NSUserDefaults中拿到UserAgent
    NSDictionary * dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:UserAgentString, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] setObject:UserAgentString forKey:@"User-Agent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    
    
    _tabBarController = [UITabBarController new];
    [_tabBarController.tabBar setTintColor:MainColor];
    _tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    [self creatViewControllerView:[HomeViewController new] andTitle:@"首页" andImage:@"tab_home" andSelectedImage:@"tab_home_selected"];
    [self creatViewControllerView:[CategoryViewController new] andTitle:@"分类" andImage:@"tab_category" andSelectedImage:@"tab_category_selected"];
    [self creatViewControllerView:[CartViewController new] andTitle:@"购物车" andImage:@"tab_shopcar" andSelectedImage:@"tab_shopcar_selected"];
    [self creatViewControllerView:[MineViewController new] andTitle:@"我的" andImage:@"tab_mine" andSelectedImage:@"tab_mine_selected"];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:MainColor];
    //此属性可以让导航栏的颜色与主题色保持一致，但会导致原本64的高度差消失！！！！！！！！！！！！！！！！！！！！！！！！！
    [UINavigationBar appearance].translucent = NO;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}   forState:UIControlStateNormal];

    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}



//创建视图控制器
-(void)creatViewControllerView:(BaseViewController *)VC andTitle:(NSString *)titleString andImage:(NSString *)image andSelectedImage:(NSString *)selectedImage
{
    if([titleString isEqualToString:@"首页"])
    {
        VC.urlString = [MayiURLManage MayiWebURLManageWithURL:Home];
    }
    else if([titleString isEqualToString:@"分类"])
    {
        VC.urlString = [MayiURLManage MayiWebURLManageWithURL:Category];
    }
    else if([titleString isEqualToString:@"购物车"])
    {
        VC.urlString = [MayiURLManage MayiWebURLManageWithURL:Cart];
    }
    else if([titleString isEqualToString:@"我的"])
    {
        VC.urlString = [MayiURLManage MayiWebURLManageWithURL:Mine];
    }
    VC.tabBarItem.title = titleString;
    VC.tabBarItem.image =[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *NVC = [[UINavigationController alloc]initWithRootViewController:VC];
    [_tabBarController addChildViewController:NVC];
    
    
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    
    // 支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            MyLog(@"支付宝: result = %@",resultDic);
            
            switch ([resultDic[@"resultStatus"] intValue])
            {
                case 9000:
                {
                    MyLog(@"支付成功");
                    [self PaySuccess];
                }
                    break;
                case 6001:
                {
                    MyLog(@"支付取消");
                    [self PayCancel];
                }
                    break;
                default:
                {
                    MyLog(@"支付失败");
                    [self PayFail];
                }
                    break;
            }
            
            
        }];
    }
    

    // 微信跳转回来的
    if([urlString containsString:WXAPPID])
    {
        // 登录回调
        if([urlString containsString:@"oauth"])
        {
            // 分割获取code  @"wxfe2e1687ec8a27af://oauth?code=001SpTig1XcNJy0pDAjg1kExig1SpTiz&state=mayi_shop"
            
            NSArray *arrayA = [urlString componentsSeparatedByString:@"code="];
            NSString *stringA = arrayA[1];
            NSArray *arrayB = [stringA componentsSeparatedByString:@"&"];
            NSString *code = arrayB[0];
            
            MyLog(@"%@",code);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXLoginSuccess" object:self userInfo:@{@"info":code}];
        }
        // 支付回调
        else if([urlString containsString:@"pay"])
        {
            NSArray *array = [urlString componentsSeparatedByString:@"ret="];
            NSInteger ret = [array[1] integerValue];
            switch (ret)
            {
                case 0:
                {
                    MyLog(@"支付成功");
                    [self PaySuccess];
                    
                }
                    break;
                case -2:
                {
                    MyLog(@"支付取消");
                    [self PayCancel];
                    
                }
                    break;
                default:
                {
                    MyLog(@"支付失败");
                    [self PayFail];

                }
                    break;
                    
            }
            
        }

        
    }
    
    [WXApi handleOpenURL:url delegate:nil];
    
    return YES;
}



//获取当前屏幕显示的viewcontroller
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}













// ★★★★★ 下面两个方法好像没用噢

// 这个方法是用于从微信返回第三方App，无论是第三方登录还是分享都用到
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

// 发送一个sendReq后，收到微信的回应
-(void) onResp:(BaseResp*)resp
{
    UIViewController *currentVC = [self topViewController];
    
    MyLog(@"%@",resp);
    
    /*
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     
     */
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //发送通知。
            SendAuthResp *resp2 = (SendAuthResp *)resp;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXLoginSuccess" object:self userInfo:@{@"info":resp2.code}];
            
        }else{ //失败

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [currentVC presentViewController:alert animated:YES completion:^{
            }];
            
        }
    }
    
    
    if ([resp isKindOfClass:[PayResp class]]) {
        
        PayResp *response = (PayResp *)resp;
        
        [self managerDidRecvPaymentResponse:response];
        
    }
    

}



- (void)managerDidRecvPaymentResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            MyLog(@"微信支付成功");
            break;
        case WXErrCodeUserCancel:
            MyLog(@"微信支付取消");
            break;
        default:{
            MyLog(@"微信支付失败");
        }
            
            break;
    }
}




// ==================================

-(void)PaySuccess
{
    BaseViewController *currentVC = (BaseViewController *)[self topViewController];
    NSString *URL = @"";
    
    if([MYManage defaultManager].CurrentPaytype==0) // 商品购
    {
        NSString *outTradeNo = [[NSUserDefaults standardUserDefaults] valueForKey:@"outTradeNo"];
        URL = [NSString stringWithFormat:@"%@%@",[MayiURLManage MayiWebURLManageWithURL:PaySuccess],outTradeNo];
    }
    else if([MYManage defaultManager].CurrentPaytype==1) // 门店购
    {
        URL = [NSString stringWithFormat:@"%@",[MayiURLManage MayiWebURLManageWithURL:EnterShopSuccess]];
    }
    else if([MYManage defaultManager].CurrentPaytype==2) // 扫码购
    {
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [currentVC.webView loadRequest:request];
    });
    
    
    
}

-(void)PayFail
{
    BaseViewController *currentVC = (BaseViewController *)[self topViewController];
    NSString *URL = @"";
    
    if([MYManage defaultManager].CurrentPaytype==0) // 商品购
    {
        NSString *outTradeNo = [[NSUserDefaults standardUserDefaults] valueForKey:@"outTradeNo"];
        URL = [NSString stringWithFormat:@"%@%@",[MayiURLManage MayiWebURLManageWithURL:PayFail],outTradeNo];
    }
    else if([MYManage defaultManager].CurrentPaytype==1) // 门店购
    {
        URL = [NSString stringWithFormat:@"%@",[MayiURLManage MayiWebURLManageWithURL:EnterShopFail]];
    }
    else if([MYManage defaultManager].CurrentPaytype==2) // 扫码购
    {
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
    dispatch_async(dispatch_get_main_queue(), ^{
        [currentVC.webView loadRequest:request];
    });
    
}

-(void)PayCancel
{
    BaseViewController *currentVC = (BaseViewController *)[self topViewController];
    NSString *URL = @"";
    
    if([MYManage defaultManager].CurrentPaytype==0) // 商品购
    {
        NSString *outTradeNo = [[NSUserDefaults standardUserDefaults] valueForKey:@"outTradeNo"];
        URL = [NSString stringWithFormat:@"%@%@",[MayiURLManage MayiWebURLManageWithURL:PayFail],outTradeNo];
    }
    else if([MYManage defaultManager].CurrentPaytype==1) // 门店购
    {
        URL = [NSString stringWithFormat:@"%@",[MayiURLManage MayiWebURLManageWithURL:EnterShopCancel]];
    }
    else if([MYManage defaultManager].CurrentPaytype==2) // 扫码购
    {
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
    dispatch_async(dispatch_get_main_queue(), ^{
        [currentVC.webView loadRequest:request];
    });
}



@end
