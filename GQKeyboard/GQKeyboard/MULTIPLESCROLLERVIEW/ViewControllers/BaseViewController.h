//
//  BaseViewController.h
//  GQMiddleBar
//
//  Created by Guangquan Yu on 2018/3/30.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseViewController;
@protocol BaseViewControllerDelegate <NSObject>

- (void)vc:(BaseViewController *)vc heihgtChange:(CGFloat)vcHeight;

@end

@interface BaseViewController : UIViewController
@property (nonatomic, weak) id<BaseViewControllerDelegate> hDelegate;
- (CGFloat)getContentHeight;
- (void)updateFrameWithHeight:(CGFloat)height;
- (void)selfFrame:(CGRect)frame;
@end
