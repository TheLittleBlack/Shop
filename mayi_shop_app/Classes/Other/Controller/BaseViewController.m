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

@interface BaseViewController ()<UIWebViewDelegate>

{
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}

@property(nonatomic,strong)NSURLRequest *request;

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    if(self.request)
    {
        [self.webView loadRequest:self.request];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新零兽";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction)];
    
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(scanButtonAction)];
    
    
    self.navigationItem.rightBarButtonItems = @[searchButton,scanButton];
    
    
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
        NSURL *url = [NSURL URLWithString:_urlString];
        self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
//        [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [_webView loadRequest:self.request];
    }
    return _webView;
}


#pragma mark <UIWebViewDelegate>

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
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
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    // 以 JSExport 协议关联 native 的方法
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



-(void)searchButtonAction
{
    MyLog(@"查找");
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
    
    // 这个判断有毒
    //    if (![WXApi isWXAppInstalled]) {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"mayi_shop";
    [WXApi sendReq:req];
    //    }
    //    else {
    //        [self setupAlertController];
    //    }
}






@end
