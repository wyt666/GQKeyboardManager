//
//  GQKeyboardManager.h
//  GQKeyboardNoCoverView
//
//  Created by Guangquan Yu on 2018/4/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

@interface GQKeyboardManager : NSObject

@property(nonatomic, weak) UIView * textEditView;

/**
 是否开启功能
 */
@property(nonatomic, assign, getter = isEnabled) BOOL enable;

/**
 是否开启工具条
 */
@property(nonatomic, assign, getter = isEnableAutoToolbar) BOOL enableAutoToolbar;

+ (GQKeyboardManager *)share;
@end
