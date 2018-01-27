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
    SaveDaily ,//保存日报
    SearchDataQuery ,//日程数据查询
    CheckoutVisit ,//检查是否存在未完成拜访
    UploadImage, //上传图片
    SignIn, // 签到
    SaveImage, // 保存图片
    SaveVisit, // 拜访总结保存
    TakeOutVisitInformation, // 取出拜访所有明细信息
    Logout, // 退出登录
    FinishVisit, // 完成拜访
    getNoFinishVisit, // 获取未完成的拜访详情
    UnreadMessageStatistics, // 未读消息统计
    MessageList, // 消息列表
    UpdateMessage, // 消息状态更新
    SubmitDeviceToken, // 提交设备
    CheckUpdate, // 更新检测
    SaveCustomerPhoto, // 客户管理拍照储存
};


typedef NS_ENUM(NSUInteger,MayiWebUrlType) {
    
    PersonCenter, // 个人中心
    ChangePassword, // 修改密码
    MessageDetails, // 消息详情
    TeamManage, // 团队管理
    TeamVisit, // 团队拜访
    PlanVisit, // 规划拜访
    WorkLog, // 工作日志
    CustomerManagement, // 客户管理
    CollaborativeApproval, // 协同审批
    OrderManagement, // 订单管理
    ResultsQuery, // 业绩查询
    ActivitiesCheck, // 活动检查
    VisitDetails, // 查看拜访详情
    Message, // 未知消息
    GetMessage, // 获取消息详情的正真路径。我也不知道为什么这么奇怪。
    OrderDown, // 订单执行
    CheckApproval, // 查看待办事务
    
};

+(NSString *)MayiURLManageWithURL:(MayiURLType)MayiUrlType;
+(NSString *)MayiWebURLManageWithURL:(MayiWebUrlType)MayiWebUrlType;

@end
