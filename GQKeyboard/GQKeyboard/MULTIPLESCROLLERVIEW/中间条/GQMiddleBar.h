//
//  GQMiddleBar.h
//  GQMiddleBar
//
//  Created by Guangquan Yu on 2018/3/30.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GQMiddleBar;
@protocol GQMiddleBarDelegate <NSObject>

- (void)didSelectedIndex:(NSInteger)index title:(NSString *)title;
@end

@protocol GQScrollContentViewDelegateForBar;
@interface GQMiddleBar : UIView <GQScrollContentViewDelegateForBar>

@property(nonatomic, strong) NSArray <NSString *>* titles;

@property(nonatomic, weak) id<GQMiddleBarDelegate> delegate;
@property(nonatomic, weak) id<GQMiddleBarDelegate> vcDelegate;
- (void)selfFrame:(CGRect)frame;
- (void)scrollRatio:(CGFloat)ratio;
- (void)finishSet;
@end
