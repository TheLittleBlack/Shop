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

@interface BaseViewController ()<UIWebViewDelegate>

{
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}

@end

@implementation BaseViewController

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
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
//        [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [_webView loadRequest:request];
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
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = request.URL;
    MyLog(@"请求的URL：%@",URL);
    
    NSArray *urlArray = [[NSString stringWithFormat:@"%@",URL] componentsSeparatedByString:@"."];
    NSString *actionType = urlArray.lastObject;
    MyLog(@"点击事件类型：%@",actionType);
    [self urlActionType:actionType];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    NSString *lastStr = [urlStr substringWithRange:NSMakeRange(urlStr.length-4, 4)];
    
    // 自动返回
    if([actionType isEqualToString:@"timeout"])
    {

        [Hud showText:@"登录信息过期，请重新登录" withTime:2];
        
    }

    
    return YES;
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    MyLog(@"web加载出错：%@",[error localizedDescription]);
    [Hud stop];
    [_progressLayer finishedLoad];
    [Hud showText:@"网络错误"];
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
