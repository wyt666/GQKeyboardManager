//
//  XLTextView.m
//  XLPlayShip
//
//  Created by Guangquan Yu on 2018/3/15.
//  Copyright © 2018年 txtechnologies. All rights reserved.
//

#import "XLTextView.h"

@implementation XLTextView

- (instancetype)initWithFrame:(CGRect)frame Font:(float)fontSize{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [NSString stringWithString:placeholder];
    
    UILabel * label = [[UILabel alloc]init];
    label.font = self.font;
    label.textColor = [UIColor grayColor];
    label.text = _placeholder;
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];
}

@end
