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

-(void)wxLogin;
-(void)scanCode;
-(void)wxpay:(NSString *)order;
-(void)callPhone:(NSString *)number;
-(void)goHomePage;

@end


@interface BaseViewController : UIViewController<UIWebViewDelegate,TestJSExport>

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *urlString;
@property (strong, nonatomic) JSContext *context;



@end
