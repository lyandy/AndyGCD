//
//  AndyGCDConst.h
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/2/23.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ANDYGCD_EXTERN UIKIT_EXTERN

#define AndyGCDAssert(condition, desc, ...)  NSAssert(condition, desc, ##__VA_ARGS__)

#define AndyGCDDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(instead)

