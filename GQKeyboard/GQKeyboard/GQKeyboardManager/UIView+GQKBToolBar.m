//
//  UIView+GQKBToolBar.m
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 YUGQ. All rights reserved.
//

#import "UIView+GQKBToolBar.h"

@implementation UIView (GQKBToolBar)

- (void)gq_addDoneOnKeyboardWithTarget:(id)target action:(SEL)action titleText:(NSString*)titleText
{
    if (![self respondsToSelector:@selector(setInputAccessoryView:)])    return;
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:flexibleSpace];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:action];
    [items addObject:doneButton];
    [toolbar setItems:items];
    toolbar.frame = CGRectMake(0, 0, 0, 44);
    [(UITextField*)self setInputAccessoryView:toolbar];
}

- (void)gq_addPreviousNextRightOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction rightButtonAction:(SEL)rightButtonAction titleText:(NSString*)titleText
{
    if (![self respondsToSelector:@selector(setInputAccessoryView:)])    return;
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIImage *imageLeftArrow = [UIImage imageNamed:@"GQKBArrowLeft"];
    UIImage *imageRightArrow = [UIImage imageNamed:@"GQKBArrowRight"];
    UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithImage:imageLeftArrow style:UIBarButtonItemStylePlain target:target action:previousAction];
    [items addObject:prev];
    UIBarButtonItem *fixed =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixed setWidth:20];
    [items addObject:fixed];
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithImage:imageRightArrow style:UIBarButtonItemStylePlain target:target action:nextAction];
    [items addObject:next];
    UIBarButtonItem *fixed1 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixed1 setWidth:20];
    [items addObject:fixed1];
    UIBarButtonItem *fixed2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:fixed2];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:rightButtonAction];
    [items addObject:doneButton];
    [toolbar setItems:items];
    toolbar.frame = CGRectMake(0, 0, 0, 44);
    [(UITextField*)self setInputAccessoryView:toolbar];
}

-(void)gq_setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled
{
    UIToolbar *inputAccessoryView = (UIToolbar*)[self inputAccessoryView];
    if ([inputAccessoryView isKindOfClass:[UIToolbar class]] && [[inputAccessoryView items] count]>3)
    {
        UIBarButtonItem *prevButton = (UIBarButtonItem*)[[inputAccessoryView items] objectAtIndex:0];
        UIBarButtonItem *nextButton = (UIBarButtonItem*)[[inputAccessoryView items] objectAtIndex:2];
        if ([prevButton isKindOfClass:[UIBarButtonItem class]] && [nextButton isKindOfClass:[UIBarButtonItem class]])
        {
            if (prevButton.enabled != isPreviousEnabled)
                [prevButton setEnabled:isPreviousEnabled];
            if (nextButton.enabled != isNextEnabled)
                [nextButton setEnabled:isNextEnabled];
        }
    }
}

@end
