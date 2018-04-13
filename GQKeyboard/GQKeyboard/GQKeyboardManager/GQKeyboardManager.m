//
//  GQKeyboardManager.m
//  GQKeyboardNoCoverView
//
//  Created by Guangquan Yu on 2018/4/11.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQKeyboardManager.h"
#import <UIKit/UINavigationBar.h>
#import <UIKit/UITapGestureRecognizer.h>
#import <UIKit/UITextField.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITableViewController.h>
#import <UIKit/UINavigationController.h>
#import <UIKit/UITableView.h>
#import <UIKit/UITouch.h>
#import <UIKit/UICollectionView.h>
#import <UIKit/UIWindow.h>

#import "UIView+Responder.h"
#import "GQKeyboardManager+ToolBar.h"
#import "UIViewController+EndEdit.h"
static GQKeyboardManager * shareKB = nil;
@interface GQKeyboardManager()<UIGestureRecognizerDelegate>

@end

@implementation GQKeyboardManager
{
    UITapGestureRecognizer  *_tapGesture;
    __block CGRect _textEditViewOriginalFrame;
    __block CGRect _textEditViewOriginalFrameForWindow;
    __block CGRect _textEditViewRootVCOriginalFrame;
    __block CGRect _textEditViewCurrentRootVCFrame;
    __block CGPoint _superOriginalContentOffset;
    __block CGSize _superOriginalContentSize;
    __block UIEdgeInsets _superOriginalContentInset;
    __block CGSize _superOriginalFrameSize;
    __weak UIScrollView * _superScrollView;
    __weak UIViewController * _textEditViewRootVC;
    BOOL            _kbShow;
    NSInteger       _kbCurve;
    CGFloat         _move ;
    CGFloat         _kbDuration;
    CGFloat         _keyboardDistanceFromTextField;
    CGSize          _kbSize;
    CGPoint         _superCurrentContentOffset;
}

+ (GQKeyboardManager *)share{
    
    if(shareKB == nil){
        shareKB = [[GQKeyboardManager alloc]init];
    }
    return shareKB;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditViewDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];

        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        _tapGesture.cancelsTouchesInView = NO;
        [_tapGesture setDelegate:self];

        self.enable = YES;
        self.enableAutoToolbar = NO;
        [self toNULL];
    }
    return self;
}

- (void)toNULL{

    _textEditView = nil;
    _textEditViewOriginalFrame = CGRectZero;
    _textEditViewOriginalFrameForWindow = CGRectZero;

    _textEditViewRootVC = nil;
    _textEditViewRootVCOriginalFrame = CGRectZero;
    
    _superScrollView = nil;
    _superOriginalContentOffset = CGPointZero;
    _superOriginalContentSize = CGSizeZero;
    _superOriginalFrameSize = CGSizeZero;
    _superOriginalContentInset = UIEdgeInsetsZero;
    
    _kbSize = CGSizeZero;
    _kbDuration = 0;
    _kbCurve = 0;
    _move = 0;
    _kbShow = NO;
    _keyboardDistanceFromTextField = 10;
    _superCurrentContentOffset = CGPointZero;
    _textEditViewCurrentRootVCFrame = CGRectZero;

}

-(void)dealloc
{
    [self toNULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gq_startToolBar{

        if ([_textEditView isKindOfClass:[UITextView class]] && _textEditView.inputAccessoryView == nil) {
            [UIView animateWithDuration:0.00001 delay:0 options:0 animations:^{
                [self gq_addToolbarIfRequired];
            } completion:^(BOOL finished) {
                [_textEditView reloadInputViews];
            }];
        }
        else {
            [self gq_addToolbarIfRequired];
        }
}


-(void)textEditViewDidBeginEditing:(NSNotification*)notification
{
    if (_enable == NO) return;

    _textEditView = notification.object;

    if (_enableAutoToolbar)
    {
        [self gq_startToolBar];
    }

    UIScrollView *superScrollView = (UIScrollView*)[_textEditView gq_findFatherViewByClass:[UIScrollView class] isMember:NO];
    if (!_superScrollView) {
        if (superScrollView && (superScrollView.isScrollEnabled == YES)) {
            NSMutableArray * scrollVs = @[].mutableCopy;
            scrollVs = [superScrollView gq_findFatherViewByClass:[UIScrollView class] mutableArray:scrollVs isMember:NO];
            if (scrollVs.count > 1) {
                
                for (UIScrollView * scroll in scrollVs) {
                    if (scroll.contentSize.height <= scroll.frame.size.height) {
                        continue;
                    } else {
                        superScrollView = scroll;
                        break;
                    }
                    
                }
            }
            _superScrollView = superScrollView;
            _superOriginalContentInset = superScrollView.contentInset;
            _superCurrentContentOffset = superScrollView.contentOffset;
            _superOriginalContentOffset = superScrollView.contentOffset;
            _superOriginalContentSize = superScrollView.contentSize;
            _superOriginalFrameSize = superScrollView.frame.size;
            
        }
    } else {
        if (superScrollView && (superScrollView.isScrollEnabled == YES)) {
            if (superScrollView != _superScrollView) {
                
                if (_superScrollView == nil) {
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [UIView setAnimationDuration:_kbDuration];
                    [UIView setAnimationCurve:_kbCurve];
                    [UIView setAnimationDelegate:self];
                    
                    _textEditViewRootVC.view.frame = _textEditViewRootVCOriginalFrame;
                    
                    [UIView commitAnimations];
                    
                    [_textEditViewRootVC.view setNeedsLayout];
                    [_textEditViewRootVC.view setNeedsDisplay];
                    [_textEditViewRootVC.view layoutIfNeeded];
                    
                } else {
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [UIView setAnimationDuration:_kbDuration];
                    [UIView setAnimationCurve:_kbCurve];
                    [UIView setAnimationDelegate:self];
                    _superScrollView.contentOffset = _superOriginalContentOffset;
                    [UIView commitAnimations];
                    _superScrollView.contentSize = _superOriginalContentSize;
                    _superScrollView.contentInset = _superOriginalContentInset;
                }
                
                NSMutableArray * scrollVs = @[].mutableCopy;
                scrollVs = [superScrollView gq_findFatherViewByClass:[UIScrollView class] mutableArray:scrollVs isMember:NO];
                if (scrollVs.count > 1) {
                    for (UIScrollView * scroll in scrollVs) {
                        if (scroll.contentSize.height <= scroll.frame.size.height) {
                            
                            continue;
                        } else {
                            superScrollView = scroll;
                            break;
                        }
                    }
                }
                _superScrollView = superScrollView;
                _superOriginalContentOffset = superScrollView.contentOffset;
                _superOriginalContentSize = superScrollView.contentSize;
                _superOriginalFrameSize = superScrollView.frame.size;
                _superCurrentContentOffset = superScrollView.contentOffset;
                _superOriginalContentInset = superScrollView.contentInset;
                
                
            } else {
                _superCurrentContentOffset = _superScrollView.contentOffset;
            }
        }
    }
    
    if (_textEditViewRootVC) {
        _textEditViewCurrentRootVCFrame = _textEditViewRootVC.view.frame;
    }
    
    [_textEditView.window addGestureRecognizer:_tapGesture];
    
    _textEditViewOriginalFrame = _textEditView.frame;
    
    if (_kbShow == NO) {
        _textEditViewRootVC = [_textEditView gq_topMostController];
        if (_textEditViewRootVC == nil)  _textEditViewRootVC = [UIWindow gq_topMostControllerForStack];
        
        _textEditViewRootVCOriginalFrame = _textEditViewRootVC.view.frame;
    }
    
    _textEditViewOriginalFrameForWindow = [[_textEditView superview] convertRect:_textEditViewOriginalFrame toView:[UIWindow gq_getWindow]];
    
    if (_superScrollView == nil) {
        CGRect frame = _textEditViewOriginalFrameForWindow;
        frame.origin.y += -_textEditViewCurrentRootVCFrame.origin.y;
        _textEditViewOriginalFrameForWindow = frame;
    }
    
    if ([_textEditView isKindOfClass:[UITextView class]]) {
        [self keyboardWillShow:nil];
    }

}

-(void)textEditViewDidEndEditing:(NSNotification*)notification
{
    UIView * editView = notification.object;
    if (_textEditView == editView) {
        [_textEditView.window removeGestureRecognizer:_tapGesture];
        _textEditView.frame = _textEditViewOriginalFrame;
        _textEditViewOriginalFrame = CGRectZero;
        _textEditView = nil;
    }
}

-(void)keyboardWillShow:(NSNotification*)aNotification
{
    if (_enable == NO)    return;

    if (aNotification) {

        NSTimeInterval animationDuration;
        CGRect keyBoardEndFrame;
        NSDictionary * userInfo = aNotification.userInfo;
        [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardEndFrame];
        NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        _kbSize = keyBoardEndFrame.size;
        _kbDuration = animationDuration;
        _kbCurve = curve.integerValue;

    }
    
    
    if (_kbDuration&&_textEditView) {
        CGSize kbSize = _kbSize;
        kbSize.height += _keyboardDistanceFromTextField;
        CGFloat move = 0 ;
        move = CGRectGetMaxY(_textEditViewOriginalFrameForWindow)-  (CGRectGetHeight([UIWindow gq_getWindow].frame)-kbSize.height);
        _move = move;
        if (_move < 0 && _superCurrentContentOffset.y < - _move) {
            _move = -_superCurrentContentOffset.y;
        }
        if (_superScrollView == nil) {
            if (_move > 0) {
                
                [_textEditViewRootVC gqkbEndEdit];
                
                CGRect frame = _textEditViewRootVCOriginalFrame;
                frame.origin.y -= _move;
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView setAnimationDuration:_kbDuration];
                [UIView setAnimationCurve:_kbCurve];
                [UIView setAnimationDelegate:self];
                
                _textEditViewRootVC.view.frame = frame;
                
                [UIView commitAnimations];
            }
        } else {
            
            CGFloat contentHeight = MAX(_superOriginalContentSize.height, _superOriginalFrameSize.height) ;
            
            CGFloat offY = (contentHeight-_superOriginalFrameSize.height-_superCurrentContentOffset.y) ;
            if ( _move > offY ) {
                UIEdgeInsets insets = _superOriginalContentInset;
                insets.bottom = _move - offY;
                _superScrollView.contentInset = insets;
            }
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:_kbDuration];
            [UIView setAnimationCurve:_kbCurve];
            [UIView setAnimationDelegate:self];
            
            _superScrollView.contentOffset = CGPointMake(_superCurrentContentOffset.x , _superCurrentContentOffset.y + _move);
            
            [UIView commitAnimations];
        }
    }
}

-(void)keyboardDidShow:(NSNotification*)aNotification
{
    if (_enable == NO)    return;
    _kbShow = YES;
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if (_enable == NO)    return;

    if (_superScrollView == nil) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:_kbDuration];
        [UIView setAnimationCurve:_kbCurve];
        [UIView setAnimationDelegate:self];
        
        _textEditViewRootVC.view.frame = _textEditViewRootVCOriginalFrame;
        
        [UIView commitAnimations];
        
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:_kbDuration];
        [UIView setAnimationCurve:_kbCurve];
        [UIView setAnimationDelegate:self];
        _superScrollView.contentOffset = _superOriginalContentOffset;
        [UIView commitAnimations];
        _superScrollView.contentSize = _superOriginalContentSize;
        _superScrollView.contentInset = _superOriginalContentInset;
    }
    
    [_textEditViewRootVC.view setNeedsLayout];
    [_textEditViewRootVC.view setNeedsDisplay];
    [_textEditViewRootVC.view layoutIfNeeded];
    
    [self toNULL];
}

- (void)keyboardDidHide:(NSNotification*)aNotification
{
    if (_enable == NO)    return;
    [_textEditViewRootVC.view setNeedsLayout];
    [_textEditViewRootVC.view setNeedsDisplay];
    [_textEditViewRootVC.view layoutIfNeeded];
    [self toNULL];
}

- (void)tapRecognized:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [_textEditView resignFirstResponder];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ([[touch view] isKindOfClass:[UITextView class]] || [[touch view] isKindOfClass:[UITextField class]]) ? NO : YES;
}


@end
