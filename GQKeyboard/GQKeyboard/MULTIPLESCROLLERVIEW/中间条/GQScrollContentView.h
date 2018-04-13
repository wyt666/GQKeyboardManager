//
//  GQScrollContentView.h
//  GQMiddleBar
//
//  Created by Guangquan Yu on 2018/3/30.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQMiddleBar.h"
#import "BaseViewController.h"

@class GQScrollContentView;
@protocol GQScrollContentViewDelegateForBar <NSObject>
- (void)contentView:(GQScrollContentView *)contentView scrollRatio:(CGFloat)ratio;

@end
@protocol GQScrollContentViewDelegateForVC <NSObject>
- (void)contentView:(GQScrollContentView *)contentView didSelected:(NSInteger)index;
@end

@interface GQScrollContentView : UIView <UIScrollViewDelegate, GQMiddleBarDelegate>
@property(nonatomic, weak) id<GQScrollContentViewDelegateForVC> vcDelegate;
@property(nonatomic, weak) id<GQScrollContentViewDelegateForBar> barDelegate;
@property(nonatomic, strong) UIScrollView * scrollView;

- (void)bindVCs:(NSArray <BaseViewController *>*)vcs superVC:(UIViewController *)superVC;
- (void)selfFrame:(CGRect)frame;
- (void)updateFrameWithHeight:(CGFloat)height;
- (void)finishSet;

@end
