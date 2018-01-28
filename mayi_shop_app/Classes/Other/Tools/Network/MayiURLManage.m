//
//  MayiURLManage.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/10.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "MayiURLManage.h"

@implementation MayiURLManage


+(NSString *)MayiURLManageWithURL:(MayiURLType)MayiUrlType
{
    
    NSString *baseURL;
    
    switch (MayiUrlType)
    {
        case LoginURL:
        {
            baseURL = @"app/login.htm"; //登录
        }
            break;
        case AlipayUrl:
        {
            baseURL = @"/api/pay/get_alipay_property.htm"; //获取支付宝订单信息
        }
            break;
        case WXPay_Url:
        {
            baseURL = @"/api/pay/wx_place_order.htm"; //获取微信订单信息
        }
            break;
            
            

    }
    
    // 判断环境    0 使用测试服务器     1 使用正式服务器
    
    NSString *url = [MainURL stringByAppendingString:baseURL];
    
    MyLog(@"URL = %@",url);
    
    return url;
    
}




+(NSString *)MayiWebURLManageWithURL:(MayiWebUrlType)MayiWebUrlType
{

    
    NSString *baseURL;
    
    switch (MayiWebUrlType)
    {
        case Home:
        {
            baseURL = [NSString stringWithFormat:@"/shop/%@.htm",SMID]; //首页
        }
            break;
        case Category:
        {
            baseURL = [NSString stringWithFormat:@"/shop/all_category.htm?smid=%@",SMID]; //分类
        }
            break;
        case Cart:
        {
//            baseURL = @"/personal/home.htm"; // 购物车
            baseURL = @"/cart/mycart.htm"; // 购物车
           
        }
            break;
        case Mine:
        {
            baseURL = @"/personal/home.htm"; // 我的
        }
            break;

            
    }
    
    // 判断环境    0 使用测试服务器     1 使用正式服务器
    
    NSString *url = [MainURL stringByAppendingString:baseURL];
    
    MyLog(@"URL = %@",url);
    
    
    return url;
    
}

@end
