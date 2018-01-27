//
//  NSString+GetWidth.m
//  HappySend
//
//  Created by JianRen on 17/4/22.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "NSString+GetWidth.h"

@implementation NSString (GetWidth)

-(CGFloat)getStringWidthWithFont:(UIFont *)font
{
      return [self sizeWithAttributes:@{NSFontAttributeName:font}].width+2;
}

@end
