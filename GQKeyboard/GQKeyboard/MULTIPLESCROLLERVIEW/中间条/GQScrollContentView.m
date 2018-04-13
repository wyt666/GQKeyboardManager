//
//  GQScrollContentView.m
//  GQMiddleBar
//
//  Created by Guangquan Yu on 2018/3/30.
//  Copyright © 2018年 ZHM.YU. All rights reserved.
//

#import "GQScrollContentView.h"

@interface GQScrollContentView ()
@property(nonatomic, strong) NSMutableArray <BaseViewController *>* vcs;

@end

@implementation GQScrollContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _vcs = @[].mutableCopy;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)bindVCs:(NSArray <BaseViewController *>*)vcs superVC:(UIViewController *)superVC
{
    if (_vcs.count>0) {
        [_vcs removeAllObjects];
    }
    
    [_vcs addObjectsFromArray:vcs];
    
    for (UIViewController * vc in vcs) {
        [superVC addChildViewController:vc];
        [vc didMoveToParentViewController:superVC];
        
        [self.scrollView addSubview:vc.view];
    }
    
    
}

- (void)finishSet{}

- (void)selfFrame:(CGRect)frame{
    self.frame = frame;
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.vcs.count, self.frame.size.height);
    for (int i=0; i<self.vcs.count; i++) {
        BaseViewController * vc = self.vcs[i];

        [vc selfFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height)];
    }
}

- (void)updateFrameWithHeight:(CGFloat)height{
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.vcs.count, height);
    
}

#pragma mark - UIScrollViewDelegate代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    
    NSInteger currentIndex = floor(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    
    if (currentIndex < 0) {
        currentIndex = 0;
    }
    
    else if (currentIndex > self.vcs.count - 1) {
        currentIndex = self.vcs.count - 1;
    }
    
    if (self.vcDelegate && [self.vcDelegate respondsToSelector:@selector(contentView:didSelected:)]) {
        [self.vcDelegate contentView:self didSelected:currentIndex];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat scrollRatio = offset/self.frame.size.width;
    
    if (self.barDelegate && [self.barDelegate respondsToSelector:@selector(contentView:scrollRatio:)]) {
        [self.barDelegate contentView:self scrollRatio:scrollRatio];
    }
}

- (void)didSelectedIndex:(NSInteger)index title:(NSString *)title{


    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * index, 0)
                             animated:YES];
    
}

#pragma mark - lazying

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled                  = YES; 
        _scrollView.backgroundColor                = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate                       = self;
    }
    return _scrollView;
}



@end
