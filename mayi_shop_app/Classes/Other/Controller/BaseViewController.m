//
//  BaseViewController.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/1/24.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "BaseViewController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import "ScanQRCodeViewController.h"
#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>

@interface BaseViewController ()<UIWebViewDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate>

{
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    BOOL _goToNearShop;
}

@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)CLLocationManager *manager;
@property(nonatomic,assign)CGFloat longitude; // 经度
@property(nonatomic,assign)CGFloat latitude; // 纬度
@property(nonatomic,strong)NSString *locationName;

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.request)
    {
        [self.webView loadRequest:self.request];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新零兽";
    
    
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(scanButtonAction)];
    
    
    self.navigationItem.rightBarButtonItems = @[scanButton];
    
    
    [self.view addSubview:self.webView];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.mas_equalTo(0);
        
    }];
    
    
}


-(UIWebView *)webView
{
    if(!_webView)
    {
        
        _webView = [UIWebView new];
        _webView.scalesPageToFit = YES;
        _webView.userInteractionEnabled = YES;
        _webView.delegate = self;
        NSURL *url = [NSURL URLWithString:self.urlString];
        self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
        [_webView loadRequest:self.request];
    }
    return _webView;
}


#pragma mark <UIWebViewDelegate>

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_progressLayer finishedLoad]; // 先结束掉上个请求的进度
    
    MyLog(@"开始加载");
    
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 0, ScreenWidth, 3)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
    
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
    [Hud stop];
    [_progressLayer finishedLoad];

    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 原生调用JS
//    NSString *textJS = [NSString stringWithFormat:@"findNearbyShop(121.395284,31.241389,'上海')"];
//    [self.context evaluateScript:textJS];
    
    NSString *textJS = [NSString stringWithFormat:@"findNearbyShop(%f,%f,'%@','gps')",self.longitude,self.latitude,self.locationName];
    [self.context evaluateScript:textJS];

    
    // JS调用原生
    self.context[@"ScanCode"] = self;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *URL = request.URL;
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    MyLog(@"请求的URL：%@",urlStr);
    
    // 过滤main路径
    NSString *actionType = [urlStr stringByReplacingOccurrencesOfString:MainURL withString:@""];
    
    MyLog(@"请求类型：%@",actionType);
    [self urlActionType:actionType];
    
    if([actionType containsString:@"show_nearby_shop.htm"]) // 附近门店
    {
        _goToNearShop = YES;
        [self getLocation];
    }
    else
    {
        _goToNearShop = NO;
    }
    
    
    if([actionType containsString:@"/wxpay/pay.htm"]) // 调起微信支付标识
    {
        MyLog(@"调起微信支付标识");
    }
    
    if([actionType containsString:@"wxpay?outTradeNo"]) // 微信订单字符串
    {
        MyLog(@"微信订单字符串");
        
        // 获取outTradeNo
        NSArray *array = [actionType componentsSeparatedByString:@"outTradeNo="];
        NSString *outTradeNo = array[1];
        [[NSUserDefaults standardUserDefaults] setObject:outTradeNo forKey:@"outTradeNo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:WXPay_Url] withPrameters:@{@"outTradeNo":outTradeNo} result:^(id result) {
            
            NSString *dataString = result[@"data"];
            // json转字典
            NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            [MYManage defaultManager].CurrentPaytype = 0; // 记录支付类型
            // 跳转微信支付
            PayReq *req = [[PayReq alloc] init];
            req.openID = WXAPPID;
            req.partnerId = [data objectForKey:@"partnerid"];
            req.prepayId = [data objectForKey:@"prepayid"];
            req.package = [data objectForKey:@"package"];
            req.nonceStr = [data objectForKey:@"noncestr"];
            req.timeStamp = [[data objectForKey:@"timestamp"] unsignedIntValue];
            req.sign = [data objectForKey:@"sign"];
            [WXApi sendReq:req];
            
        } error:^(id error) {
            
        } withHUD:YES];
        

        return NO;
    }

    if([actionType containsString:@"/alipay/pay.htm"]) // 调起支付宝支付
    {
        MyLog(@"调起支付宝支付");
        
    }
    
//    @"mymma://alipay?out_trade_no=T_O_FK180203000007001&total_fee=99.02&subject=%E8%AE%A2%E5%8D%95+-+180203000007"
    if([actionType containsString:@"alipay?out_trade_no"]) // 支付宝支付订单信息
    {
        MyLog(@"支付宝支付订单信息");

        // 获取outTradeNo
        NSArray *array = [actionType componentsSeparatedByString:@"out_trade_no="];
        NSString *string = array[1];
        NSString *outTradeNo = [[string componentsSeparatedByString:@"&"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:outTradeNo forKey:@"outTradeNo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:AlipayUrl] withPrameters:@{@"outTradeNo":outTradeNo} result:^(id result) {
            
            NSString *dataString = result[@"data"];
            
            [MYManage defaultManager].CurrentPaytype = 0; // 记录支付类型
            
            [[AlipaySDK defaultService] payOrder:dataString fromScheme:URLSchemes callback:^(NSDictionary *resultDic) {
                MyLog(@"reslut = %@",resultDic);
            }];
            
        } error:^(id error) {
            
        } withHUD:YES];
        
        

        
        return NO;
    }
    
    if([actionType containsString:@"login.htm"]) // 登录拦截
    {
        if(self.tabBarController.selectedIndex!=3)
        {
            self.tabBarController.selectedIndex = 3; // 跳转
            return NO;
        }

    }

    
    return YES;
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    MyLog(@"web加载出错：%@",[error localizedDescription]);
    [Hud stop];
    [_progressLayer finishedLoad];
   
}


-(void)urlActionType:(NSString *)actionString
{
    
}


-(void)scanButtonAction
{
    MyLog(@"扫一扫");
    ScanQRCodeViewController *SQVC = [ScanQRCodeViewController new];
    SQVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:SQVC animated:YES];
}



- (void)wxLogin
{
    MyLog(@"微信登录");
    
    // 这个判断有毒?
    if([self booWeixin])
    {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"mayiShop";
        [WXApi sendReq:req];
    }
}

-(void)scanCode
{
    MyLog(@"JS调用扫一扫");
    [self scanButtonAction];
}

-(void)wxpay:(NSString *)order;
{
    MyLog(@"JS调用微信支付");
    // 跳转微信支付
    
    [MYManage defaultManager].CurrentPaytype = 1; // 记录支付类型（门店购）
    
    // json转字典
    NSData *jsonData = [order dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    PayReq *req = [[PayReq alloc] init];
    req.openID = WXAPPID;
    req.partnerId = [data objectForKey:@"partnerid"];
    req.prepayId = [data objectForKey:@"prepayid"];
    req.package = [data objectForKey:@"package"];
    req.nonceStr = [data objectForKey:@"noncestr"];
    req.timeStamp = [[data objectForKey:@"timestamp"] unsignedIntValue];
    req.sign = [data objectForKey:@"sign"];
    [WXApi sendReq:req];
}
-(void)callPhone:(NSString *)number
{
    MyLog(@"JS调用打电话%@",number);
    if(number&&![number isEqualToString:@""]&&![number isEqualToString:@"null"])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIWebView *callWebView = [[UIWebView alloc] init];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
            [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebView];
            
        });
        
       
    }
}
-(void)goHomePage
{
    MyLog(@"JS调用返回首页");
    if(self.tabBarController.selectedIndex !=0 )
    {
        self.tabBarController.selectedIndex = 0;
    }
    else
    {
        NSString *HomeURL = [MayiURLManage MayiWebURLManageWithURL:Home];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:HomeURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:request];
        });

        
    }

}



// 判断是否安装微信及是否支持当前调用的api
-(BOOL)booWeixin{
    
    if ([WXApi isWXAppInstalled])
    {
        //判断当前微信的版本是否支持OpenApi
        if ([WXApi isWXAppSupportApi])
        {
            return YES;
        }
        else{

            [self showAlterWithTitle:@"请升级微信至最新版本！"];
            return NO;
        }
    }else{

        [self showAlterWithTitle:@"请安装微信客户端"];
        return NO;
    }
    
}


// 获取定位
-(void)getLocation
{
    
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        
        [self showAlterWithTitle:@"请开启定位服务，我们需要获取您的地理位置"];
        
        return ;
        
    }
    
    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    self.manager.distanceFilter = 100; // 每隔多少米定位一次
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;  //定位精确度（越精确就越耗电）
    if([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.manager requestWhenInUseAuthorization];
    }
    
    [self.manager startUpdatingLocation];
}

-(void)stopLocation
{
    [self.manager stopUpdatingLocation];
}

#pragma mark Location Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    MyLog(@"经度：%f", locations.lastObject.coordinate.longitude);
    MyLog(@"纬度：%f", locations.lastObject.coordinate.latitude);
    self.longitude = locations.lastObject.coordinate.longitude;
    self.latitude = locations.lastObject.coordinate.latitude;

    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSDictionary *locationInfo = [[NSDictionary alloc]init];
        
        for (CLPlacemark * placemark in placemarks) {
            
            locationInfo = [placemark addressDictionary];
            
        }
        
        MyLog(@"位置:%@",locationInfo[@"Name"]);
        self.locationName = locationInfo[@"Name"];
        
        
        
        // 原生调用JS
        NSString *textJS = [NSString stringWithFormat:@"findNearbyShop(%f,%f,'%@')",self.longitude,self.latitude,self.locationName];
        [self.context evaluateScript:textJS];
        

        

        
    }];
    
    
    // 只需获取一次位置
    [self stopLocation];
    

   
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    MyLog(@"%@",error);
}


// 弹出Alter
-(void)showAlterWithTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    // 为了不产生延时的现象，直接放在主线程中调用
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    });
}


-(void)logCookie
{

    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        NSDictionary *dict = cookie.properties;
        NSLog(@"+++++++++%@$+++++++++",dict);
    }
}

// 保存cookie
-(void)setCookie:(NSDictionary *)properties
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:[NSHTTPCookie cookieWithProperties:properties]];
}

// 清除cookie
-(void)deleteCookie
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies])
    {
        [cookieJar deleteCookie:cookie];
    }
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    MyLog(@"ss");
//}



@end
