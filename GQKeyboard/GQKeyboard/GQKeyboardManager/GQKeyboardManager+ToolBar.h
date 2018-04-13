//
//  GQKeyboardManager+ToolBar.h
//
//  Created by Guangquan Yu on 2018/4/13.
//  Copyright © 2018年 YUGQ. All rights reserved.
//

#import "GQKeyboardManager.h"

@interface GQKeyboardManager (ToolBar)

@property(nonatomic, assign) NSInteger sortType;

-(void)gq_addToolbarIfRequired;

-(void)gq_removeToolbarIfRequired;

- (void)gq_reloadInputViews;
@end
