//
//  NSString+DealTimestamp.h
//  HappySend
//
//  Created by JianRen on 17/5/11.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DealTimestamp)

//只显示年月日
-(NSString *)dealTimestampWithYearMonthDate;
//正常格式
-(NSString *)dealTimestamp;
//只显示时分秒
-(NSString *)dealTimestampWithHoursMinutesSeconds;
//只显示时分
-(NSString *)dealTimestampWithHoursMinutes;
//只显示月日时分
-(NSString *)dealTimestampWithMonthDayHoursMinutes;
//只显示月日
-(NSString *)dealTimestampWithMonthDate;
@end
