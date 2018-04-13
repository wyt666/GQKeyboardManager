//
//  IHBaseInformationCell.h
//  iHome
//
//  Created by zzz on 16/6/26.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHBaseInformationModel.h"
@interface IHBaseInformationCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label1;//title

@property (weak, nonatomic) IBOutlet UITextField *textField1;//title num

@property (weak, nonatomic) IBOutlet UIView *line1;
@property(nonatomic,weak)UIImageView * imageView1;


@property(nonatomic,copy)IHBaseInformationModel * model;
@property(nonatomic,copy)void(^beginEditBlock)(UITextField*);

@property(nonatomic,copy)void(^endEditBlock)(UITextField*);

@end
