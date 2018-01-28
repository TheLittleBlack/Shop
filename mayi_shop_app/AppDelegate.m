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

@interface AppDelegate ()

@property(nonatomic,strong)UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    // 支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            MyLog(@"支付宝: result = %@",resultDic);
            
            NSString *resultStatus; //支付结果
            NSString *price; //本次支付价格
            NSString *time; //支付时间
            UIViewController *currentVC = [self topViewController];
            
            switch ([resultDic[@"resultStatus"] intValue])
            {
                    
                case 9000:
                {
                    resultStatus = @"支付成功";
                    
                }
                    break;
                case 8000:
                {
                    resultStatus = @"正在处理中";
                }
                    break;
                case 4000:
                {
                    resultStatus = @"支付失败";
                }
                    break;
                case 5000:
                {
                    resultStatus = @"重复请求";
                }
                    break;
                case 6001:
                {
                    resultStatus = @"取消支付";
                }
                    break;
                case 6002:
                {
                    resultStatus = @"网络错误";
                }
                    break;
                case 6004:
                {
                    resultStatus = @"支付结果未知";
                }
                    break;
                    
                default:
                {
                    resultStatus = @"未知错误";
                }
                    break;
            }
            
            if([resultDic[@"resultStatus"] intValue] == 9000)
            {
                NSString *str = resultDic[@"result"];
                
                NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dicA = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
                MyLog(@"dicA = %@",dicA);
                NSDictionary *dicB = dicA[@"alipay_trade_app_pay_response"];
                time = dicB[@"timestamp"];
                price = [NSString stringWithFormat:@"%@元",dicB[@"total_amount"]];
                
                
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"充值成功" message:[NSString stringWithFormat:@"本次充值:%@",price] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    

                        
                        
                    }]];
                    
                    [currentVC presentViewController:alert animated:YES completion:^{
                    }];
                    
                
                
                
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@",resultStatus] preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [currentVC presentViewController:alert animated:YES completion:^{
                }];
            }
            
            
            
            
            
        }];
    }
    
    
    
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

@end
