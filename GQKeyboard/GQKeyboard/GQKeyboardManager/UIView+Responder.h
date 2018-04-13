//
//  UIView+Responder.h
//  ResponseChain
//
//  Created by GuangquanYu on 10/4/18.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Responder)

@property(nonatomic, copy) NSString * tagString;

-(BOOL)gq_isCanBecomeFirstResponder;

- (NSArray*)gq_responderSiblings;

- (NSArray*)gq_responderChildViews;


-(UIViewController*)gq_viewController;

-(UIViewController *)gq_topMostController;

- (NSMutableArray*)gq_findSonViewByClass:(Class)type mutableArray:(NSMutableArray *)sonViews isMember:(BOOL)isMember;


- (UIView *)gq_findFatherViewByClass:(Class)type isMember:(BOOL)isMember;

- (NSMutableArray*)gq_findFatherViewByClass:(Class)type mutableArray:(NSMutableArray *)fatherViews isMember:(BOOL)isMember;

- (NSInteger)gq_depth;

@end

@interface UIWindow (Responder)
+ (UIWindow *)gq_getWindow;

+ (UIViewController *)gq_getWindowRootVC;

+ (UIViewController *)gq_getRootViewController;

+ (UIViewController*)gq_topMostControllerForStack;

+ (UINavigationController *)gq_topMostNavigationController;

+ (UIViewController*)gq_currentNavigationViewController;

+ (UIViewController*)gq_currentViewController;

@end
