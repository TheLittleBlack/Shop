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
    NSString *urlProtocol = @"http://";
    
    NSString *baseURL;
    
    switch (MayiUrlType)
    {
        case LoginURL:
        {
            baseURL = @"app/login.htm"; //登录
        }
            break;
        case SaveDaily:
        {
            baseURL = @"app/daily/insert_daily_log.htm";  //保存日报
        }
            break;
        case SearchDataQuery:
        {
            baseURL = @"app/visit/get_daily_project.htm"; //日程数据查询
        }
            break;
        case CheckoutVisit:
        {
            baseURL = @"app/visit/isexist_visitproject_ing.htm";  //检查是否存在未完成拜访
        }
            break;
        case UploadImage:
        {
            baseURL = @"upload/uploadImg.htm"; //上传图片
        }
            break;
        case SignIn:
        {
            baseURL = @"app/visit/insert_visit_gps.htm";  //签到
        }
            break;
        case SaveImage:
        {
            baseURL = @"app/visit/insert_visit_photo.htm";  // 保存图片
        }
            break;
        case SaveVisit:
        {
            baseURL = @"app/visit/insert_visit_log.htm";  // 拜访总结保存
        }
            break;
        case TakeOutVisitInformation:
        {
            baseURL = @"app/visit/get_visit_project_detail.htm";  // 取出拜访所有明细信息
        }
            break;
        case Logout:
        {
            baseURL = @"app/logout.htm";  // 登出
        }
            break;
        case FinishVisit:
        {
            baseURL = @"app/visit/done_visitproject.htm";  // 完成拜访
        }
            break;
        case getNoFinishVisit:
        {
            baseURL = @"app/visit/insert_daily_log.htm";  // 获取未完成的拜访详情
        }
            break;
        case UnreadMessageStatistics:
        {
            baseURL = @"app/notice/find_notice_counts.htm";  // 未读消息统计
        }
            break;
        case MessageList:
        {
            baseURL = @"app/notice/find_notice.htm";  // 消息列表
        }
            break;
        case UpdateMessage:
        {
            baseURL = @"app/notice/update_notice.htm";  // 消息状态更新
        }
            break;
        case SubmitDeviceToken:
        {
            baseURL = @"insert_and_update_device_token.htm";  // 提交设备
        }
            break;
        case CheckUpdate:
        {
            baseURL = @"download/getVerInfoForIOS.htm";  // 更新检测
        }
            break;
        case SaveCustomerPhoto:
        {
            baseURL = @"app/customer/insert_photo_info.htm";  // 客户管理拍照储存
        }
            break;
            
       

     
      
    }
    
    // 判断环境    0 使用测试服务器     1 使用正式服务器
    
    NSString *url;
    
    if(ConfigureServer==0)
    {
        url = [[urlProtocol stringByAppendingString:@"121.43.165.156:18088/api/"] stringByAppendingString:baseURL];
        
        MyLog(@"URL = %@",url);
    }
    else if(ConfigureServer==1)
    {
        url = [[urlProtocol stringByAppendingString:@""] stringByAppendingString:baseURL];
        
        MyLog(@"URL = %@",url);
    }
    
    
    return url;
    
}




+(NSString *)MayiWebURLManageWithURL:(MayiWebUrlType)MayiWebUrlType
{
    NSString *urlProtocol = @"http://";
    
    NSString *baseURL;
    
    switch (MayiWebUrlType)
    {
        case LoginURL:
        {
            baseURL = @"/#/personCenter"; //个人中心
        }
            break;
        case ChangePassword:
        {
            baseURL = @"#/resetPassword"; //修改密码
        }
            break;
        case MessageDetails:
        {
            baseURL = @"#/examine/commonDetail/"; // 消息详情 后面接消息id
        }
            break;
        case TeamManage:
        {
            baseURL = @"#/group"; // 团队管理
        }
            break;
        case TeamVisit:
        {
            baseURL = @"#/customerVisit"; // 团队拜访
        }
            break;
        case PlanVisit:
        {
            baseURL = @"#/temporaryVisit1"; // 规划拜访
        }
            break;
        case WorkLog:
        {
            baseURL = @"#/myDaily"; // 工作日志
        }
            break;
        case CustomerManagement:
        {
            baseURL = @"/#/customerManage"; // 客户管理
        }
            break;
        case CollaborativeApproval:
        {
            baseURL = @"/#/examine/approvalList"; // 协同审批
            
        }
            break;
        case OrderManagement:
        {
            baseURL = @"/#/orderList"; // 订单管理
        }
            break;
        case ResultsQuery:
        {
            baseURL = @" "; // 业绩查询
        }
            break;
        case ActivitiesCheck:
        {
            baseURL = @" "; // 活动检查
        }
            break;
        case VisitDetails:
        {
            baseURL = @"/#visitDetail/"; // 查看拜访详情
        }
            break;
        case Message:
        {
            baseURL = @"/#/msgDetail"; // 未知消息
        }
            break;
        case GetMessage:
        {
            baseURL = @"#"; // 获取消息详情的正真路径
        }
            break;
        case OrderDown:
        {
            baseURL = @"#/orderDown"; // 订单执行
        }
            break;
        case CheckApproval:
        {
            baseURL = @"#/examine/myApproval"; // 查看待办事务
        }
            break;
        

            
    }
    
    // 判断环境    0 使用测试服务器     1 使用正式服务器
    
    NSString *url;
    
    if(ConfigureServer==0)
    {
        url = [[urlProtocol stringByAppendingString:@"121.43.165.156:18088"] stringByAppendingString:baseURL];
        
        MyLog(@"URL = %@",url);
    }
    else if(ConfigureServer==1)
    {
        url = [[urlProtocol stringByAppendingString:@""] stringByAppendingString:baseURL];
        
        MyLog(@"URL = %@",url);
    }
    
    
    return url;
    
}

@end
