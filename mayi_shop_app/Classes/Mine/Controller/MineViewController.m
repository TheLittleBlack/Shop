//
//  MineViewController.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/1/24.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "MineViewController.h"
#import "WXApi.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLoginSuccess:) name:@"WXLoginSuccess" object:nil];
    
}




#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先安装微信客户端" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)WXLoginSuccess:(NSNotification *)notification
{
    
    MyLog(@"登录授权成功，接下来获取access_token及用户信息");
    NSString *code = notification.userInfo[@"info"];
    
    NSString *loginURL = [NSString stringWithFormat:@"%@%@",[MayiURLManage MayiWebURLManageWithURL:WXLogin],code];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:loginURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
    [self.webView loadRequest:request];
    
    MyLog(@"%@",loginURL);
    
    __weak typeof(*&self) weakSelf = self;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain",nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,WXSecret,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        /*
         access_token   接口调用凭证
         expires_in access_token接口调用凭证超时时间，单位（秒）
         refresh_token  用户刷新access_token
         openid 授权用户唯一标识
         scope  用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* openID=[dic valueForKey:@"openid"];
        
        // 拿到这两个后可以请求其他信息
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
    
    
}




-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"用户信息获取成功  ====  dic  ==== %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
    }];
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}



@end
