//
//  GQMiddleBar.m
//  GQMiddleBar
//
//  Created by Guangquan Yu on 2018/3/30.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQMiddleBar.h"
#import "GQScrollContentView.h"

#define GQTAG 110
@interface GQMiddleBar ()
@property(nonatomic, assign)BOOL isClick;
@property(nonatomic, assign)NSInteger isClickIndex;

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, strong) NSMutableArray <UIButton *>* views;
@property(nonatomic, strong) UIView * bottomLine;
@property(nonatomic, assign) CGFloat selfWidth;
@property(nonatomic, assign) CGFloat selfHeight;
@property(nonatomic, assign) CGFloat scrollOffsetRatio;
@end

@implementation GQMiddleBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = @[].mutableCopy;
        _isClick = NO;
        
    }
    return self;
}

- (void)selfFrame:(CGRect)frame
{
    self.frame = frame;
    self.selfWidth = frame.size.width;
    self.selfHeight = frame.size.height;
}

- (void)makeUI
{
    
    
    if (_views.count) {
        [_views removeAllObjects];
    }
    
    for (int i=0;i<_titles.count;i++) {
        NSString * title = _titles[i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = GQTAG + i;
        [button setTitle:title forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:64];
        [self addSubview:button];
        [_views addObject:button];
    }
    
    [self addSubview:self.bottomLine];
}

- (void)makeFrame
{
    for (int i=0; i<_views.count; i++) {
        UIView * v = _views[i];
        v.frame = [self getChildFrame:i type:@"title"];
    }
    
    self.bottomLine.frame = [self getChildFrame:0 type:@"bottomLine"];
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles.copy;
    
    [self makeUI];
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger index = button.tag - GQTAG;
    
    _isClick = YES;
    _isClickIndex = index;
    
//    [self scrollRatio:index];
    
    
    
    if (self.vcDelegate && [self.vcDelegate respondsToSelector:@selector(didSelectedIndex:title:)]) {
        [self.vcDelegate didSelectedIndex:index title:_titles[_selectedIndex]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedIndex:title:)]) {
        [self.delegate didSelectedIndex:index title:_titles[_selectedIndex]];
    }
}

- (CGRect)getChildFrame:(NSInteger)index type:(NSString *)type{
    if ([type isEqualToString:@"title"]) {
        CGFloat allWidth = self.selfWidth;
        CGFloat childWidth = allWidth/(_views.count);
        CGFloat childX = childWidth * index;
        CGFloat childY = 0;
        CGFloat childHeight = self.selfHeight;
        return CGRectMake(childX, childY, childWidth, childHeight);
    } else if ([type isEqualToString:@"bottomLine"]) {
        CGFloat allWidth = self.selfWidth;
        CGFloat childWidth = allWidth/(_views.count);
        
        CGFloat edge = 10;
        CGFloat lineWidth = (childWidth-edge*2)>0?(childWidth-edge*2):10;
        CGFloat childX = childWidth * index + edge;
        CGFloat childY = self.selfHeight-1;
        CGFloat childHeight = 1;
        return CGRectMake(childX, childY, lineWidth, childHeight);
    }
    return CGRectZero;
}

- (void)finishSet{
    [self makeFrame];
}


- (void)contentView:(GQScrollContentView *)contentView scrollRatio:(CGFloat)ratio
{
    [self scrollRatio:ratio];
}

- (void)scrollRatio:(CGFloat)ratio
{
    _scrollOffsetRatio = ratio;
    NSInteger selectedIndex = round(ratio);
    NSInteger lastSelectedIndex = _selectedIndex;

    if (_isClick) {
        if (selectedIndex == _isClickIndex) {
            for (int i=0; i<self.views.count; i++) {
                NSInteger oldButtonTag = GQTAG + i;
                UIButton * oldButton = [self viewWithTag:oldButtonTag];
                oldButton.selected = NO;
            }
  
            NSInteger newButtonTag = GQTAG + selectedIndex;
            UIButton * newButton = [self viewWithTag:newButtonTag];
            newButton.selected = YES;
            
            _isClick = NO;
        }
        
    } else {
        NSInteger oldButtonTag = GQTAG + lastSelectedIndex;
        UIButton * oldButton = [self viewWithTag:oldButtonTag];
        oldButton.selected = NO;
        NSInteger newButtonTag = GQTAG + selectedIndex;
        UIButton * newButton = [self viewWithTag:newButtonTag];
        newButton.selected = YES;
    }
    
    
    self.bottomLine.frame = [self getChildFrame:selectedIndex type:@"bottomLine"];
    
    _selectedIndex = selectedIndex;
}

#pragma mark - lazying

- (UIView *)bottomLine{
    if (!_bottomLine) {
        UIView * v = [[UIView alloc]init];
        v.backgroundColor = [UIColor blackColor];
        _bottomLine = v;
    }
    return _bottomLine;
}

@end
