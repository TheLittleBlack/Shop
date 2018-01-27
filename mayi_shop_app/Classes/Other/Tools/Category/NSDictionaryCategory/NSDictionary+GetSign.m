//
//  NSDictionary+GetSign.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/10.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "NSDictionary+GetSign.h"
#import "NSString+MD5.h"

@implementation NSDictionary (GetSign)

//获取sign
-(NSString *)getSignString
{
    //将字典key进行排序后拼接成一个字符串
    NSString *string =  [self getKeyValueString];
    MyLog(@"拼接后的字符串:%@",string);
    
    // 3.拼接后的字符串如果长度超过100，则取前100个字符
    if(string.length>100)
    {
       string =  [string substringToIndex:100];
    }
    
    MyLog(@"过滤长度超过100:%@",string);
    
    //将 string 拼接上 jsy:mayi
    NSString *stringB = [string stringByAppendingString:@"jsy:mayi"];
    MyLog(@"加盐:%@",stringB);
    
    //再进行MD5加密 得到sign
    NSString *sign = [stringB encryptionWithMD5];
    
    MyLog(@"加密后的code值:%@",sign);
    
    return sign;
}



-(NSString *)getKeyValueString
{
    //如果只有1个键值对 则直接拼接
    if(self.keyEnumerator.allObjects.count ==1)
    {
        NSString *string = [NSString stringWithFormat:@"%@=%@",self.allKeys.firstObject,self.allValues.firstObject];
        
        return string;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    
    //遍历字典中所有的key 添加到数组中
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [array addObject:key];
        
    }];
    
    //升序
    NSArray *resultArray =  [self ascendingWithArray:array];
    MyLog(@"升序后: %@",resultArray);
    
    //将排序后的value值按顺序拼接
    NSString *stringA = @"";
    
    for (int i =0; i<resultArray.count; i++)
    {
        NSString *key = resultArray[i];
        // 排除掉 sign token dataFile
        if(![key isEqualToString:@"sign"] && ![key isEqualToString:@"token"] && ![key isEqualToString:@"dataFile"])
        {
            if(i==0)
            {
                stringA = [NSString stringWithFormat:@"%@=%@",resultArray[0],self[resultArray[0]]];
            }
            else
            {
                stringA = [stringA stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",resultArray[i],self[resultArray[i]]]];
            }
        }

    }
    
    return stringA;
    
}

//升序
-(NSArray *)ascendingWithArray:(NSArray *)array
{
    
    
    //对key进行升序排序
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch ];
    }];
    
    return sortArray;
    
    
}

@end
