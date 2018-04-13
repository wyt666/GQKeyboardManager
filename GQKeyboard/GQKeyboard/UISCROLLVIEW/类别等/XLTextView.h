//
//  XLTextView.h
//  XLPlayShip
//
//  Created by Guangquan Yu on 2018/3/15.
//  Copyright © 2018年 txtechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLTextView : UITextView

@property(nonatomic,copy)NSString * placeholder;

- (instancetype)initWithFrame:(CGRect)frame Font:(float)fontSize;

@end
