//
//  MYManage.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/12.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "MYManage.h"

@implementation MYManage

//创建一个静态变量  用来保存实例
static MYManage *_myManage;

//提供一个类方法
+(instancetype)defaultManager
{
    return [[MYManage alloc]init];
}


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _myManage = [super allocWithZone:zone];
    });
    
    return _myManage;
}


-(id)copyWithZone:(NSZone *)zone
{
    //既然是实例方法 说明要调用此方法时已经存在了一个该类的实例 所以直接把静态变量_ayqManage返回出来即可
    return _myManage;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _myManage;
}

//-(void)setDataWithDictionary:(NSDictionary *)dic
//{
//    _agencyId = dic[@"agencyId"];
//    _agencyName = dic[@"agencyName"];
//    _createOperator = dic[@"createOperator"];
//    _customUserType = dic[@"customUserType"];
//    _mobile = dic[@"mobile"];
//    _organizationName = dic[@"organizationName"];
//    _status = dic[@"status"];
//    _userName = dic[@"userName"];
//    _userType = dic[@"userType"];
//    _ID = dic[@"id"];
//}
//
//-(void)setUserInfoWithDictionary:(NSDictionary *)dic
//{
//    _address = dic[@"address"];
//    _passport = dic[@"passport"];
//}



//-(void)clearAllData
//{
//    _token = nil;
//    _agencyId = nil;
//    _agencyName = nil;
//    _createOperator = nil;
//    _customUserType = nil;
//    _mobile = nil;
//    _organizationName = nil;
//    _status = nil;
//    _userName = nil;
//    _userType = nil;
//    _address = nil;
//}

@end
