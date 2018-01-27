//
//  NSString+URLEncoded.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/10.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "NSString+URLEncoded.h"

@implementation NSString (URLEncoded)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

@end
