//
//  CViewController.m
//  GQMiddleBar
//
//  Created by Guangquan Yu on 2018/3/30.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "CViewController.h"
#import "UIView+GQMakeUI.h"
@interface CViewController ()
@property(nonatomic, assign)BOOL isChange;
@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    for (int i = 0; i<3; i++) {
        UILabel * v = [[UILabel alloc]initWithFrame:CGRectMake(20, 10 +(10+300)*i, 200, 300)];
        v.text = [NSString stringWithFormat:@"%d", i];
        v.backgroundColor = [UIColor redColor];
        [self.view addSubview:v];
        
        UITextField * tfphone = [UITextField new];
        tfphone.backgroundColor = [UIColor orangeColor];
        tfphone.placeholder = @"请输入信息";
        tfphone.textColor = [UIColor blackColor];
        tfphone.font = [UIFont systemFontOfSize:13];
        tfphone.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:tfphone];
        tfphone.frame = CGRectMake(40, 10 +(10+300)*i, SCREENWIDTH-40, 300);
        
    }
    
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(50, 10 +(300)*2, 100, 30)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"改变高度" forState:0];
    [button setTitleColor:[UIColor redColor] forState:0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:64];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button
{
    _isChange = YES;
    [self heihgtChange];
}

- (CGFloat)getContentHeight{
    if (_isChange) {
        return 10 +(10+300)*2 + 500 +10;
    }
    
    return 10 +(10+300)*2 + 300 +10;
}

- (void)selfFrame:(CGRect)frame{
    self.view.frame = frame;
}

- (void)updateFrameWithHeight:(CGFloat)height{

    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, height);
}

- (void)heihgtChange{
    if (self.hDelegate && [self.hDelegate respondsToSelector:@selector(vc:heihgtChange:)]) {
        [self.hDelegate vc:self heihgtChange:[self getContentHeight]];
        
    }
}

@end

