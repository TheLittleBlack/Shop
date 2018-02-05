//
//  MayiURLManage.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/10.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MayiURLManage : NSObject

typedef NS_ENUM(NSUInteger,MayiURLType) {
    
    AlipayUrl, // 获取支付宝订单信息
    WXPay_Url, // 获取微信订单信息
    
};


typedef NS_ENUM(NSUInteger,MayiWebUrlType) {
    
    Home, // 首页
    Category, // 分类
    Cart, // 购物车
    Mine, // 我的
    PaySuccess, // 支付成功
    PayFail, // 支付失败
    BuySuccess, // 扫码购成功
    BuyFail, // 扫码购失败
    BuyCancel, // 扫码购取消
    EnterShopSuccess, // 进店购成功
    EnterShopFail, //  进店购失败
    EnterShopCancel, //  进店购取消
    WXLogin, // 微信登录
    FindNearByShop, // 附近门店列表
    CallShop, // 呼叫门店
    CancelCallShop, //取消呼叫门店
    ScanAddToCard,// 扫码加入购物车
    
};

+(NSString *)MayiURLManageWithURL:(MayiURLType)MayiUrlType;
+(NSString *)MayiWebURLManageWithURL:(MayiWebUrlType)MayiWebUrlType;

@end
