
//
//  RootTableViewController.m
//
//  Created by Guangquan Yu on 2017/8/23.
//  Copyright © 2017年 Guangquan Yu. All rights reserved.
//

#import "RootTableViewController.h"

@interface RootTableViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GQKeyboardManager";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;

    [self addCell:@"1.ViewController" class:@"ViewController"];
    [self addCell:@"2.TableView" class:@"IHBaseInformationViewController"];
    [self addCell:@"3.ScrollView" class:@"XLSupplementaryInfoViewController"];
    [self addCell:@"4.MultipleScrollView" class:@"MiddleBarViewController"];
    
    [self.tableView reloadData];

}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
