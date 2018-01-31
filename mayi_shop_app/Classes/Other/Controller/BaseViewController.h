//
//  BaseViewController.h
//  mayi_shop_app
//
//  Created by JayJay on 2018/1/24.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>
- (void)ScanCode;
- (void)WXLogin;
@end


@interface BaseViewController : UIViewController<UIWebViewDelegate,TestJSExport>

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *urlString;
@property (strong, nonatomic) JSContext *context;



@end
