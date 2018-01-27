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
    
    LoginURL ,//登录

};


typedef NS_ENUM(NSUInteger,MayiWebUrlType) {
    
    Home, // 首页
    Category, // 分类
    Cart, // 购物车
    Mine, // 我的

    
};

+(NSString *)MayiURLManageWithURL:(MayiURLType)MayiUrlType;
+(NSString *)MayiWebURLManageWithURL:(MayiWebUrlType)MayiWebUrlType;

@end
