//
//  GQKeyboardManager+ToolBar.m
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 YUGQ. All rights reserved.
//

#import "GQKeyboardManager+ToolBar.h"
#import "NSArray+GQSort.h"
#import "UIView+Responder.h"
#import <objc/runtime.h>
#import "UIView+Responder.h"
#import "UIView+GQKBToolBar.h"


#define DEF_TAGSTRING @"GQKeyboardManager.ToolBar"
#define KEY_KBSORTTYPE @"GQKeyboardManager.SortType"
@implementation GQKeyboardManager (ToolBar)

- (NSInteger)sortType
{
    return ((NSNumber *)objc_getAssociatedObject(self, KEY_KBSORTTYPE)).integerValue;

}

- (void)setSortType:(NSInteger)sortType
{
    objc_setAssociatedObject(self, KEY_KBSORTTYPE, [NSNumber numberWithInteger:sortType], OBJC_ASSOCIATION_RETAIN);
}

-(void)gq_addToolbarIfRequired
{
    NSArray * responderViews = [self gq_getResponderViews];
    if (responderViews.count==1)
    {
        UITextField *textEditView = responderViews[0];
        if ([textEditView respondsToSelector:@selector(setInputAccessoryView:)] && ((![textEditView inputAccessoryView]) || [textEditView.inputAccessoryView.tagString isEqualToString:DEF_TAGSTRING]))
        {
            textEditView.inputAccessoryView.tagString = DEF_TAGSTRING;
            [textEditView gq_addDoneOnKeyboardWithTarget:self action:@selector(doneAction:) titleText:textEditView.placeholder];
        }
    }
    else if(responderViews.count > 1)
    {
        for (UITextField *textEditView in responderViews)
        {
            if ([textEditView respondsToSelector:@selector(setInputAccessoryView:)] && ((![textEditView inputAccessoryView]) || [textEditView.inputAccessoryView.tagString isEqualToString:DEF_TAGSTRING]))
            {
                textEditView.inputAccessoryView.tagString = DEF_TAGSTRING;
                [textEditView gq_addPreviousNextRightOnKeyboardWithTarget:self previousAction:@selector(previousAction:) nextAction:@selector(nextAction:) rightButtonAction:@selector(doneAction:) titleText:textEditView.placeholder];
            }
            if ([responderViews objectAtIndex:0] == textEditView)
            {
                [textEditView gq_setEnablePrevious:NO next:YES];
            }
            else if ([responderViews lastObject] == textEditView) 
            {
                [textEditView gq_setEnablePrevious:YES next:NO];
            }
            else
            {
                [textEditView gq_setEnablePrevious:YES next:YES];
            }
        }
    }
}

-(void)gq_removeToolbarIfRequired
{
    NSArray *responderViews = [self gq_getResponderViews];
    
    for (UITextField *textEditView in responderViews)
    {
        UIView *toolbar = [textEditView inputAccessoryView];

        if ([textEditView respondsToSelector:@selector(setInputAccessoryView:)] && ([toolbar.tagString isEqualToString:DEF_TAGSTRING]))
        {
            textEditView.inputAccessoryView = nil;
        }
    }
}

- (void)gq_reloadInputViews
{
    NSArray *responderViews = [self gq_getResponderViews];
    
    for (UITextField *textEditView in responderViews)
    {
        if ([responderViews objectAtIndex:0] == textEditView)
        {
            if (responderViews.count == 1)
            {
                [textEditView gq_setEnablePrevious:NO next:NO];
            }
            else
            {
                [textEditView gq_setEnablePrevious:NO next:YES];
            }
        }
        else if ([responderViews lastObject] == textEditView)
        {
            [textEditView gq_setEnablePrevious:YES next:NO];
        }
        else
        {
            [textEditView gq_setEnablePrevious:YES next:YES];
        }
    }
}

-(void)previousAction:(id)segmentedControl
{
    if ([self gq_canGoPrevious])
    {
        [self gq_goPrevious];
    }
}

-(void)nextAction:(id)segmentedControl
{
    if ([self gq_canGoNext])
    {
        [self gq_goNext];
    }
}

-(void)doneAction:(id)barButton
{
    [self.textEditView resignFirstResponder];
}

-(NSArray*)gq_getResponderViews{
    return [self gq_getResponderViewsWithDeep:YES sortType:self.sortType];
}

-(NSArray*)gq_getResponderViewsWithDeep:(BOOL)isDeep sortType:(NSInteger)sortType
{
    NSArray * editViews = nil;
    if (isDeep) {
        UIScrollView * scrollView = (UIScrollView *)[self.textEditView gq_findFatherViewByClass:[UIScrollView class] isMember:NO];
        UIViewController * vc = [self.textEditView gq_viewController];
        if (scrollView && [scrollView isKindOfClass:[UIScrollView class]]) {
            editViews = [scrollView gq_responderChildViews];
        } else if (vc && [vc isKindOfClass:[UIViewController class]]) {
            editViews = [vc.view gq_responderChildViews];
        } else {
            editViews = [self.textEditView gq_responderChildViews];
        }
    } else {
        editViews = [self.textEditView gq_responderSiblings];
    }
    return [editViews gq_sortedUIViewArrayByPositionForWindow];;
}

-(BOOL)gq_canGoPrevious
{
    NSArray *textFields = [self gq_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index > 0)
        return YES;
    else
        return NO;
}

-(BOOL)gq_canGoNext
{
    NSArray *textFields = [self gq_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index < textFields.count-1)
        return YES;
    else
        return NO;
}

-(BOOL)gq_goPrevious
{
    NSArray *textFields = [self gq_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index > 0)
    {
        UITextField *nextTextField = [textFields objectAtIndex:index-1];
        UIView *textFieldRetain = self.textEditView;
        BOOL isAcceptAsFirstResponder = [nextTextField becomeFirstResponder];
        if (isAcceptAsFirstResponder == NO)
        {
            [textFieldRetain becomeFirstResponder];
            return NO;
        }
        return YES;
    }
    return NO;
}

-(BOOL)gq_goNext
{
    NSArray *textFields = [self gq_getResponderViews];
    NSUInteger index = [textFields indexOfObject:self.textEditView];
    if (index != NSNotFound && index < textFields.count-1)
    {
        UITextField *nextTextField = [textFields objectAtIndex:index+1];
        UIView *textFieldRetain = self.textEditView;
        BOOL isAcceptAsFirstResponder = [nextTextField becomeFirstResponder];
        if (isAcceptAsFirstResponder == NO)
        {
            [textFieldRetain becomeFirstResponder];
            return NO;
        }
        return YES;
    }
    return NO;
}

@end
