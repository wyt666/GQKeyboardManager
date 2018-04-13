//
//  UIView+GQMakeUI.m
//  XLPlayShip
//
//  Created by Guangquan Yu on 2018/3/14.
//  Copyright © 2018年 txtechnologies. All rights reserved.
//

#import "UIView+GQMakeUI.h"
#import "UIView+LCFrameLayout.h"
#import <objc/runtime.h>
#define KEY_TapBlock @"UIView.TapClickBlock"

@implementation UIView (GQMakeUI)

+(UILabel*) makeLabel:(CGRect)frame text:(NSString*)aText textColor:(UIColor*)aColor font:(UIFont *)aFont backColor:(UIColor*)aBackColor alignment:(NSTextAlignment)aTextAlignment label:(UILabel *)wLabel
{
    UILabel *label = wLabel;
    if (!label) {
        label = [[UILabel alloc]init];
    }
    
    //frame
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        label.frame = frame;
    }
    
    if (aText) {
        label.text = aText;
    }
    
    label.textAlignment = aTextAlignment;
    
    if (aBackColor) {
        label.backgroundColor = aBackColor;
    }
    
    if (aColor) {
        label.textColor = aColor;
    }
    
    if (aFont) {
        label.font = aFont;
    }
    
    return label;
}

+(UIImageView *) makeImageView:(CGRect)frame imageName:(NSString*)aImageName
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeCenter;
    if (aImageName) {
        [imageView setImage:[UIImage imageNamed:aImageName]];
    }
    return imageView;
}

-(TapAction) tapBlock
{
    return objc_getAssociatedObject(self, KEY_TapBlock);
    
}
- (void)setTapBlock:(TapAction)tapBlock
{
    objc_setAssociatedObject(self, KEY_TapBlock, tapBlock, OBJC_ASSOCIATION_COPY);
}

-(void) addTapActionWithBlock:(TapAction)block
{
    if (!self.isUserInteractionEnabled) self.userInteractionEnabled = YES;
    
    self.tapBlock = block;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapClick:)];
    [self addGestureRecognizer:tap];
}

-(void) viewTapClick:(UITapGestureRecognizer *)tap
{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

+(UIScrollView *) addSlideWithFrame:(CGRect)frame superView:(UIView *)superView subViews:(NSArray<UIView *> *)subViews bottomOffset:(CGFloat)bottomOffset{
    if (subViews.count <= 0) return nil;
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:frame];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.bounces = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    float contentHeight = 0;
    for (UIView * v in subViews) {
        [scrollView addSubview:v];
        if (v.viewBottomY > contentHeight) {
            contentHeight = v.viewBottomY;
        }
    }
    contentHeight += bottomOffset;
    [superView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame), contentHeight);
    return scrollView;
}

@end
