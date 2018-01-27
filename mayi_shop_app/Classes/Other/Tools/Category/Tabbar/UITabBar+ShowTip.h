//
//  UITabBar+ShowTip.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (ShowTip)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
