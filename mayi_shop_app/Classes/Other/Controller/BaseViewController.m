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
    
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 获取js调用的方法
    context[@"wxLogin"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        
        NSLog(@"%@",args);
        
    };
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = request.URL;
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    MyLog(@"请求的URL：%@",urlStr);
    
    
    NSString *actionType = [urlStr stringByReplacingOccurrencesOfString:MainURL withString:@""];
    
    MyLog(@"点击事件类型：%@",actionType);
    [self urlActionType:actionType];
    
    if([actionType containsString:@"/wxpay/pay.htm"]) // 调起微信支付标识
    {
        MyLog(@"调起微信支付标识");
    }
    
    if([actionType containsString:@"wxpay?outTradeNo"]) // 微信订单字符串
    {
        MyLog(@"微信订单字符串");
        return NO;
    }

    if([actionType containsString:@"/alipay/pay.htm"]) // 调起支付宝支付
    {
        MyLog(@"调起支付宝支付");
    }
    
    if([actionType containsString:@"alipay?out_trade_no"]) // 支付宝支付订单信息
    {
        MyLog(@"支付宝支付订单信息");
        return NO;
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
}

@end
