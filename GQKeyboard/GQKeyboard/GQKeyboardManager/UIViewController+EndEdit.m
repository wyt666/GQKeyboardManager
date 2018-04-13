//
//  UIViewController+EndEdit.m
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 YUGQ. All rights reserved.
//

#import "UIViewController+EndEdit.h"
#import <objc/runtime.h>

@implementation UIViewController (EndEdit)
- (void)gqkbEndEdit
{
    SEL selectors[] = {
        @selector(viewWillDisappear:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"mykb" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        SEL orig_sel = originalSelector; SEL alt_sel = swizzledSelector;
        Method orig_method = nil, alt_method = nil;
        Class aClass = [self class];
        orig_method = class_getInstanceMethod(aClass, orig_sel);
        alt_method = class_getInstanceMethod(aClass, alt_sel);
        if (class_addMethod(aClass, orig_sel, method_getImplementation(alt_method), method_getTypeEncoding(alt_method))) {
            class_replaceMethod(aClass, alt_sel, method_getImplementation(orig_method), method_getTypeEncoding(orig_method));
        }
        else{
            if ((orig_method != nil) && (alt_method != nil)) {
                method_exchangeImplementations(orig_method, alt_method);
            }
        }
    }
}


- (void)mykbviewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [self mykbviewWillDisappear:animated];
}
@end
