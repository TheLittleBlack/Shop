//
//  ScanAddToCartViewController.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/2/5.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "ScanAddToCartViewController.h"
#import "WXApi.h"

@interface ScanAddToCartViewController ()

@end

@implementation ScanAddToCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


-(void)wxpay:(NSString *)order;
{
    MyLog(@"JS调用微信支付");
    // 跳转微信支付
    
    [MYManage defaultManager].CurrentPaytype = 2; // 记录支付类型（扫码购）
    
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

@end
