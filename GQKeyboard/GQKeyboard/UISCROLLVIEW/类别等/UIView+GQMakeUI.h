//
//  UIView+GQMakeUI.h
//  XLPlayShip
//
//  Created by Guangquan Yu on 2018/3/14.
//  Copyright © 2018年 txtechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTextView.h"

#undef  lazyloading_implementation
#define lazyloading_implementation(returnType, propertyName, ...)   -(returnType)propertyName{ \
if (!_##propertyName) {\
_##propertyName = __VA_ARGS__\
}\
return _##propertyName;\
};

#undef  lazyloading_implementationn
#define lazyloading_implementationn(returnType, propertyName, ...)   -(returnType)propertyName{ \
if (!_##propertyName) {\
__VA_ARGS__\
}\
return _##propertyName;\
};

#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCRENNSCALE (APP.width/320.f)

typedef void (^TapAction)(void);
typedef NS_ENUM(NSInteger, XLAuthorizeType) {
    XLAuthorizeTypeSuccessful     = 0,
    XLAuthorizeTypeFailure        = 1,
    XLAuthorizeTypeIng            = 2,
    XLAuthorizeTypeNO             = 3
};
@interface UIView (GQMakeUI)

+(UILabel*) makeLabel:(CGRect)frame text:(NSString*)aText textColor:(UIColor*)aColor font:(UIFont *)aFont backColor:(UIColor*)aBackColor alignment:(NSTextAlignment)aTextAlignment label:(UILabel *)wLabel;

+(UIImageView *) makeImageView:(CGRect)frame imageName:(NSString*)aImageName;

-(void) addTapActionWithBlock:(TapAction)block;

+(UIScrollView *) addSlideWithFrame:(CGRect)frame superView:(UIView *)superView subViews:(NSArray<UIView *> *)subViews bottomOffset:(CGFloat)bottomOffset;
@end
