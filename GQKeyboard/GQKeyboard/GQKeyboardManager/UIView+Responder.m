//
//  UIView+Responder.m
//  ResponseChain
//
//  Created by GuangquanYu on 10/4/18.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "UIView+Responder.h"
#import <objc/runtime.h>
#define KEY_SYSTEMVIEWTYPEARRAY @"GQUIView.SystemTypeArray"
#define KEY_TAGSTRING @"GQUIView.TagString"

@implementation UIView (Responder)
- (NSString *)tagString
{
    return objc_getAssociatedObject(self, KEY_TAGSTRING);
}

- (void)setTagString:(NSString *)value
{
    objc_setAssociatedObject(self, KEY_TAGSTRING, value, OBJC_ASSOCIATION_RETAIN);

}

-(BOOL)gq_isCanBecomeFirstResponder
{
    BOOL isCanBecomeFirstResponder = ([self canBecomeFirstResponder] && [self isUserInteractionEnabled] && ![self isHidden] && [self alpha]!=0.0);
    
    if (isCanBecomeFirstResponder == YES)
    {
        if ([self isKindOfClass:[UITextField class]])
        {
            isCanBecomeFirstResponder = [(UITextField*)self isEnabled];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            isCanBecomeFirstResponder = [(UITextView*)self isEditable];
        }
    }
    
    return isCanBecomeFirstResponder;
}

- (NSArray*)gq_responderSiblings
{
    NSArray *siblings = self.superview.subviews;
    NSMutableArray *tempTextFields = [[NSMutableArray alloc] init];
    
    for (UITextField *textField in siblings)
        if ([textField gq_isCanBecomeFirstResponder])
            [tempTextFields addObject:textField];
    
    return tempTextFields;
}

- (NSArray*)gq_responderChildViews
{
    NSMutableArray *textFields = [[NSMutableArray alloc] init];
    NSArray *subViews = self.subviews;;
    
    for (UITextField *textField in subViews)
    {
        if ([textField gq_isCanBecomeFirstResponder])
        {
            [textFields addObject:textField];
        }
        else if (textField.subviews.count)
        {
            [textFields addObjectsFromArray:[textField gq_responderChildViews]];
        }
    }

    return textFields;
}

-(UIViewController*)gq_viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

-(UIViewController *)gq_topMostController
{
    NSMutableArray *controllersHierarchy = [[NSMutableArray alloc] init];
    UIViewController *topController = self.window.rootViewController;

    if (topController)
    {
        [controllersHierarchy addObject:topController];
    }
    while ([topController presentedViewController]) {
        
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    UIResponder *matchController = [self gq_viewController];
    while (matchController != nil && [controllersHierarchy containsObject:matchController] == NO)
    {
        do
        {
            matchController = [matchController nextResponder];
            
        } while (matchController != nil && [matchController isKindOfClass:[UIViewController class]] == NO);
    }

    return (UIViewController*)matchController;
}

- (NSArray<NSString *> *)systemTypeArray
{
    if (!objc_getAssociatedObject(self, KEY_SYSTEMVIEWTYPEARRAY)) {
        NSString * UITextField0 = @"_UITextFieldContentView";
        self.systemTypeArray = @[UITextField0];
    }
    return objc_getAssociatedObject(self, KEY_SYSTEMVIEWTYPEARRAY);
}

- (void)setSystemTypeArray:(NSArray<NSString *> *)systemTypeArray
{
    objc_setAssociatedObject(self, KEY_SYSTEMVIEWTYPEARRAY, systemTypeArray, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)gq_isSystemType:(Class)class{
    NSString * classStr = NSStringFromClass(class);
    for (int i=0; i<self.systemTypeArray.count; i++) {
        if ([classStr isEqualToString:self.systemTypeArray[i]]) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray*)gq_findSonViewByClass:(Class)type mutableArray:(NSMutableArray *)sonViews isMember:(BOOL)isMember{
    UIView * superview = self;
    for (UIView *subview in superview.subviews) {
        if ([subview.subviews count] > 0) {
            [subview gq_findSonViewByClass:type mutableArray:sonViews isMember:isMember];
        }
        if (isMember) {
            if ([subview  isMemberOfClass:type]) {
                [sonViews addObject:subview];
            }
        } else {
            if ([subview  isKindOfClass:type]) {
                BOOL isSystemType = [self gq_isSystemType:[subview class]];
                if (!isSystemType) {
                    [sonViews addObject:subview];
                }
            }
        }
    }
    return sonViews;
}

- (UIView *)gq_findFatherViewByClass:(Class)type isMember:(BOOL)isMember{
    
    UIView * subview = self;
    UIView * superView = subview;
    int i = 0;
    while (superView) {
        if (isMember) {
            if ([superView.superview  isMemberOfClass:type]) {
                superView = superView.superview;
                break;
            }else{
                if ([superView.superview isKindOfClass:[UIView class]]) {
                    superView = superView.superview;
                }else{
                    superView = nil;
                    break;
                }
            }
        } else {
            BOOL isSystemType = [self gq_isSystemType:[superView.superview class]];
            if ([superView.superview  isKindOfClass:type]&&!isSystemType) {
                superView = superView.superview;
                break;
            }else{
                if ([superView.superview isKindOfClass:[UIView class]]) {
                    superView = superView.superview;
                }else{
                    superView = nil;
                    break;
                }
            }
        }
        i ++;
    }
    return superView;
    
}

- (NSMutableArray*)gq_findFatherViewByClass:(Class)type mutableArray:(NSMutableArray *)fatherViews isMember:(BOOL)isMember{
    UIView * fatherV = self;
    while (fatherV && [fatherV isKindOfClass:[UIView class]]) {
        UIView * fatherV1 = [fatherV gq_findFatherViewByClass:type isMember:isMember];
        if (fatherV && [fatherV isKindOfClass:type]) {
            [fatherViews addObject:fatherV];
        }
        fatherV = fatherV1;
    }
    
    return fatherViews;
}

- (NSInteger)gq_depth
{
    NSInteger depth = 0;
    
    if ([self superview])
    {
        depth = [[self superview] gq_depth] + 1;
    }
    
    return depth;
}
@end


@implementation UIWindow (Responder)

+ (UIWindow *)gq_getWindow{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

+ (UIViewController *)gq_getWindowRootVC
{
    UIViewController *result = nil;
    UIWindow * window = [self gq_getWindow];
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

+ (UIViewController *)gq_getRootViewController{
    UIViewController * rootVC = [self gq_getWindowRootVC];
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)rootVC;
        if (nav.childViewControllers.count > 0) {
            rootVC = nav.childViewControllers[0];
        }
    }
    return rootVC;
}

+ (UIViewController*)gq_topMostController
{
    UIViewController *topController = [self gq_getRootViewController];
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    return topController;
}

+ (UIViewController*)gq_topMostControllerForStack
{
    UIViewController *topController = [self gq_getWindowRootVC];
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    return topController;
}

+ (UINavigationController *)gq_topMostNavigationController
{
    UIViewController *topController = [self gq_getWindowRootVC];
    if ([topController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)topController;
    }
    topController = [self gq_getRootViewController];
    while ([topController presentedViewController]) {
        topController = [topController presentedViewController];
        if ([topController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)topController;
        }
    }
    return nil;
}

+ (UIViewController*)gq_currentNavigationViewController;
{
    UIViewController *currentViewController = nil;
    if ([self gq_topMostNavigationController]) {
        currentViewController = [self gq_topMostNavigationController];
        
        while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
            currentViewController = [(UINavigationController*)currentViewController topViewController];
    } else {
        currentViewController = [self gq_topMostController];
    }
    return currentViewController;
}

+ (UIViewController*)gq_currentViewController{
    UIViewController *currentViewController = [self gq_currentNavigationViewController];
    while ([currentViewController presentedViewController])    currentViewController = [currentViewController presentedViewController];
    return currentViewController;
}

@end
