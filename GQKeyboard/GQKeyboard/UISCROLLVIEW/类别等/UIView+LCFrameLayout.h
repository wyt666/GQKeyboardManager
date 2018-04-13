//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#undef  strong_pro
#define strong_pro property(nonatomic, strong)

#undef  weak_pro
#define weak_pro property(nonatomic, weak)

#undef  assign_pro
#define assign_pro property(nonatomic, assign)

#undef  readonly_pro
#define readonly_pro property(nonatomic, readonly)

#undef  copy_pro
#define copy_pro property(nonatomic, copy)

#undef  APP
#define APP ((AppDelegate *)[UIApplication sharedApplication].delegate)


@class LCLayout;



#pragma mark -

@interface LCLayoutGet : NSObject

@weak_pro LCLayout * layout;

@readonly_pro CGFloat centerX;
@readonly_pro CGFloat centerY;

@readonly_pro CGFloat x;
@readonly_pro CGFloat y;
@readonly_pro CGFloat width;
@readonly_pro CGFloat height;

@readonly_pro CGFloat rightX;
@readonly_pro CGFloat bottomY;

@readonly_pro CGFloat midWidth;
@readonly_pro CGFloat midHeight;

@end

#pragma mark -

@interface LCLayout : NSObject

@weak_pro __kindof UIView * target;




@strong_pro LCLayoutGet * get;

@end



























#pragma mark -

@interface UIView (LCFrameLayout)

@assign_pro CGPoint viewXY;
@assign_pro CGSize viewSize;

@assign_pro CGFloat viewCenterX;
@assign_pro CGFloat viewCenterY;

@assign_pro  CGFloat viewFrameX;
@assign_pro  CGFloat viewFrameY;
@assign_pro  CGFloat viewFrameWidth;
@assign_pro  CGFloat viewFrameHeight;

@readonly_pro CGFloat viewRightX;
@readonly_pro CGFloat viewBottomY;

@readonly_pro CGFloat viewMidX;
@readonly_pro CGFloat viewMidY;

@readonly_pro CGFloat viewMidWidth;
@readonly_pro CGFloat viewMidHeight;

@strong_pro LCLayout * layout;

@end

