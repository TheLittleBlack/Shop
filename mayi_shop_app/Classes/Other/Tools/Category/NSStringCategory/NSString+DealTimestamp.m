//
//  NSString+DealTimestamp.m
//  HappySend
//
//  Created by JianRen on 17/5/11.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "NSString+DealTimestamp.h"

@implementation NSString (DealTimestamp)

-(NSString *)dealTimestampWithYearMonthDate
{
    NSInteger timestamp = [self integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [formatter setDateFormat:@"yy-mm-dd hh-MM-ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
    
    
}

-(NSString *)dealTimestampWithHoursMinutesSeconds
{
    NSInteger timestamp = [self integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
    
    
}

-(NSString *)dealTimestampWithHoursMinutes
{
    NSInteger timestamp = [self integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH : mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
    
    
}

-(NSString *)dealTimestamp
{
    NSInteger timestamp = [self integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
    
    
}


-(NSString *)dealTimestampWithMonthDayHoursMinutes
{
    NSInteger timestamp = [self integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//只显示月日
-(NSString *)dealTimestampWithMonthDate
{
    NSInteger timestamp = [self integerValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}




@end
