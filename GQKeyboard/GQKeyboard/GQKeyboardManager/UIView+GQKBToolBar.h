//
//  UIView+GQKBToolBar.h
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 YUGQ. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIView (GQKBToolBar)

- (void)gq_addDoneOnKeyboardWithTarget:(id)target action:(SEL)action titleText:(NSString*)titleText;

- (void)gq_addPreviousNextRightOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction rightButtonAction:(SEL)rightButtonAction titleText:(NSString*)titleText;

-(void)gq_setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;

@end
