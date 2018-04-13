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

#import "UIView+LCFrameLayout.h"



#pragma mark -

@implementation UIView (LCFrameLayout)

-(CGPoint) viewXY
{
    return CGPointMake(self.viewFrameX, self.viewFrameY);
}

-(void) setViewXY:(CGPoint)viewXY
{
    self.viewFrameX = viewXY.x;
    self.viewFrameY = viewXY.y;
}

-(CGSize) viewSize
{
    return CGSizeMake(self.viewFrameWidth, self.viewFrameHeight);
}

-(void) setViewSize:(CGSize)viewSize
{
    self.viewFrameWidth = viewSize.width;
    self.viewFrameHeight = viewSize.height;
}

-(CGFloat) viewCenterX
{
    return self.center.x;
}

-(void) setViewCenterX:(CGFloat)viewCenterX
{
    self.center = CGPointMake(viewCenterX, self.viewCenterY);
}

-(CGFloat) viewCenterY
{
    return self.center.y;
}

-(void) setViewCenterY:(CGFloat)viewCenterY
{
    self.center = CGPointMake(self.viewCenterX, viewCenterY);
}


-(CGFloat) viewFrameX
{
    return self.frame.origin.x;
}

-(void) setViewFrameX:(CGFloat)newViewFrameX
{
    self.frame = CGRectMake(newViewFrameX, self.viewFrameY, self.viewFrameWidth, self.viewFrameHeight);
}

-(CGFloat) viewFrameY
{
    return self.frame.origin.y;
}

-(void) setViewFrameY:(CGFloat)newViewFrameY
{
    self.frame = CGRectMake(self.viewFrameX, newViewFrameY, self.viewFrameWidth, self.viewFrameHeight);
}

-(CGFloat) viewFrameWidth
{
    return self.frame.size.width;
}

-(void) setViewFrameWidth:(CGFloat)newViewFrameWidth
{
    self.frame = CGRectMake(self.viewFrameX, self.viewFrameY, newViewFrameWidth, self.viewFrameHeight);
}

-(CGFloat) viewFrameHeight
{
    return self.frame.size.height;
}

-(void) setViewFrameHeight:(CGFloat)newViewFrameHeight
{
    self.frame = CGRectMake(self.viewFrameX, self.viewFrameY, self.viewFrameWidth, newViewFrameHeight);
}

-(CGFloat) viewRightX
{
    return self.viewFrameX+self.viewFrameWidth;
}

-(CGFloat) viewBottomY
{
    return self.viewFrameY+self.viewFrameHeight;
}

-(CGFloat) viewMidX
{
    return self.viewFrameX / 2.f;
}

-(CGFloat) viewMidY
{
    return self.viewFrameY / 2.f;
}

-(CGFloat) viewMidWidth
{
    return self.viewFrameWidth / 2.f;
}

-(CGFloat) viewMidHeight
{
    return self.viewFrameHeight / 2.f;
}


@end
