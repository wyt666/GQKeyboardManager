//
//  MiddleBarViewController.m
//  GQKeyboard
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "MiddleBarViewController.h"
#import "GQMiddleBar.h"
#import "GQScrollContentView.h"

#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
@interface MiddleBarViewController ()<GQScrollContentViewDelegateForVC, GQMiddleBarDelegate, UIScrollViewDelegate, BaseViewControllerDelegate>
@property (nonatomic, strong)GQMiddleBar * bar;
@property (nonatomic, strong)GQScrollContentView * scrollV;
@property (nonatomic, strong) UIScrollView * dScrollV;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray<BaseViewController*> * controllers;
@property (nonatomic, assign) CGFloat headHeihgt;
@property (nonatomic, assign) CGFloat lastOffset;

@end

@implementation MiddleBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self makeUI];
    
}

- (void)makeUI
{
    [self.view addSubview:self.dScrollV];
    self.dScrollV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    self.dScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _headHeihgt);
    
    
    _bar = [[GQMiddleBar alloc]init];
    _bar.titles = @[@"发现", @"城市", @"帆船"];
    [_bar selfFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    _headHeihgt = 100+50;
    [_bar finishSet];
    [self.dScrollV addSubview:_bar];
    //    - (void)scrollRatio:(CGFloat)ratio;
    
    
    
    AViewController * a = [AViewController new];
    BViewController * b = [BViewController new];
    CViewController * c = [CViewController new];
    a.hDelegate = self;
    b.hDelegate = self;
    c.hDelegate = self;
    _controllers = @[a, b ,c];
    _scrollV = [[GQScrollContentView alloc]init];
    
    [_scrollV bindVCs:@[a, b ,c] superVC:self];
    [_scrollV selfFrame:CGRectMake(0, _headHeihgt, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-_headHeihgt)];
    [_scrollV finishSet];
    [self.dScrollV addSubview:_scrollV];
    
    
    _bar.delegate = _scrollV;
    _bar.vcDelegate = self;
    _scrollV.barDelegate = _bar;
    _scrollV.vcDelegate = self;
    
    
    [self updateHeight:0];
}


// 滑动选中
- (void)contentView:(GQScrollContentView *)contentView didSelected:(NSInteger)index {
    
    BaseViewController * vc = _controllers[index];
    CGFloat contentH = [vc getContentHeight];
    
    [UIView animateWithDuration:0.4 animations:^{
    
        CGFloat maxY = contentH - ([UIScreen mainScreen].bounds.size.height-64-_headHeihgt);
        if (maxY<0) {
            maxY = 0;
        }
        if (_lastOffset > maxY) {
            self.dScrollV.contentOffset = CGPointMake(0, maxY);
        }
        
        
    } completion:^(BOOL finished) {
        [self updateHeight:index];
        
    }];
}

- (void)didSelectedIndex:(NSInteger)index title:(NSString *)title {
    [self updateHeight:index];
}

- (void)updateHeight:(NSInteger)index{
    _selectedIndex = index;
    BaseViewController * vc = _controllers[index];
    CGFloat contentH = [vc getContentHeight];
    
    [_scrollV updateFrameWithHeight:contentH];
    [vc updateFrameWithHeight:contentH];
    _dScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _headHeihgt + contentH);
}

#pragma mark - 监听子控制器 滚动 和 子控制器高度

- (void)vc:(BaseViewController *)vc heihgtChange:(CGFloat)vcHeight{
    [_controllers enumerateObjectsUsingBlock:^(BaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (vc == obj) {
            [self updateHeight:idx];
        }
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _lastOffset = scrollView.contentOffset.y;
    NSLog(@"%f", _lastOffset);
    
}

#pragma mark - lazying
- (UIScrollView *)dScrollV {
    if (!_dScrollV) {
        _dScrollV = [[UIScrollView alloc] init];
        _dScrollV.pagingEnabled                  = NO;
        _dScrollV.backgroundColor                = [UIColor whiteColor];
        _dScrollV.showsHorizontalScrollIndicator = NO;
        _dScrollV.delegate                       = self;
    }
    return _dScrollV;
}

@end
