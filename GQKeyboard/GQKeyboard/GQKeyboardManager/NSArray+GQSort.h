//
//  NSArray+GQSort.h
//
//  Created by Guangquan Yu on 2018/4/9.
//  Copyright © 2018年 yugq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GQSort)

- (nonnull NSArray*)gq_sortedUIViewArrayByTag;

- (nonnull NSArray*)gq_sortedUIViewArrayByPosition;

- (nonnull NSArray*)gq_sortedUIViewArrayByPositionForWindow;

@end
