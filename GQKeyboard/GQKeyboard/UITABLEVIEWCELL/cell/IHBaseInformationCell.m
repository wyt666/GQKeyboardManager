//
//  IHBaseInformationCell.m
//  iHome
//
//  Created by zzz on 16/6/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "IHBaseInformationCell.h"

@implementation IHBaseInformationCell

- (void)awakeFromNib {
    
    UIImageView *imageViewUserName=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageViewUserName.image=[UIImage imageNamed:@""];
    imageViewUserName.contentMode = UIViewContentModeCenter;
    _imageView1 = imageViewUserName;
    _textField1.rightView=_imageView1;
    _textField1.rightViewMode=UITextFieldViewModeAlways;
//    _textField1.leftViewMode=UITextFieldViewModeNever;
    
    _textField1.delegate = self;
    
    _line1.backgroundColor = [UIColor blackColor];
    _textField1.textColor = [UIColor blackColor];
    _label1.textColor = [UIColor blackColor];
}

- (void)setModel:(IHBaseInformationModel *)model{
    _model = model;
    
    _label1.text = model.title1;
    _textField1.text = model.title2;
    _imageView1.image = [UIImage imageNamed:model.image1];



}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.beginEditBlock) {
        self.beginEditBlock(textField);
    }




}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.endEditBlock) {
        self.endEditBlock(textField);
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
