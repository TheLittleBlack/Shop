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
    
    //再进行MD5加密 得到sign
    NSString *sign = [string encryptionWithMD5];
    
    MyLog(@"加密后的code值:%@",sign);
    
    return sign;
}



-(NSString *)getKeyValueString
{
    //如果只有1个键值对 则直接拼接
    if(self.keyEnumerator.allObjects.count ==1)
    {
        NSString *string = [NSString stringWithFormat:@"%@",self.allValues.firstObject];
        string = [string stringByAppendingString:Salt];
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
        if(![key isEqualToString:@"code"] && ![key isEqualToString:@"token"] && ![key isEqualToString:@"sessionId"])
        {
            
            stringA = [stringA stringByAppendingString:[NSString stringWithFormat:@"%@",self[resultArray[i]]]];
            
        }

    }
    
    stringA = [stringA stringByAppendingString:Salt];
    
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


//降序
-(NSArray *)descendingOrderWithArray:(NSArray *)array
{
    NSArray *newArray = [self ascendingWithArray:array];
    newArray =  [[newArray reverseObjectEnumerator] allObjects];
    MyLog(@"降序后:%@",newArray);
    return newArray;
}

@end
