//
//  XLSupplementaryInfoViewController.m
//  XLPlayShip
//
//  Created by Guangquan Yu on 2018/4/10.
//  Copyright © 2018年 txtechnologies. All rights reserved.
//

#import "XLSupplementaryInfoViewController.h"
#import "UIView+GQMakeUI.h"
#import "UIView+LCFrameLayout.h"
@interface XLSupplementaryInfoViewController ()

@property(nonatomic, strong) UILabel * contact;
@property(nonatomic, strong) UILabel * contactprompt;
@property(nonatomic, strong) UILabel * name;
@property(nonatomic, strong) UILabel * phone;
@property(nonatomic, strong) UILabel * note;
@property(nonatomic, strong) UIView * linecontact;
@property(nonatomic, strong) UIView * linename;
@property(nonatomic, strong) UIView * linephone;
@property(nonatomic, strong) UITextField * tfname;
@property(nonatomic, strong) UITextField * tfphone;
@property(nonatomic, strong) XLTextView * txnote;
@property(nonatomic, strong) UIButton * submit;

@end


@implementation XLSupplementaryInfoViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.title = @"补充信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIScrollView * scroll = [UIView addSlideWithFrame:CGRectMake(0, 0, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height-64)
                                             superView:self.view
                                              subViews:@[self.contact,
                                                         self.contactprompt,
                                                         self.phone,
                                                         self.name,
                                                         self.note,
                                                         self.linecontact,
                                                         self.linename,
                                                         self.linephone,
                                                         self.tfphone,
                                                         self.tfname,
                                                         self.txnote,
                                                         self.submit,
                                                         ]
                                          bottomOffset:30];
    CAShapeLayer* dashLineShapeLayer = [CAShapeLayer layer];
    UIBezierPath* dashLinePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREENWIDTH-40, 144) cornerRadius:2];
    
    dashLineShapeLayer.path = dashLinePath.CGPath;
    dashLineShapeLayer.position = CGPointMake(20, self.note.viewBottomY+15);
    dashLineShapeLayer.fillColor = [UIColor clearColor].CGColor;
    dashLineShapeLayer.strokeColor = [UIColor colorWithRed:153/255.f green:166/255.f blue:170/255.f alpha:1].CGColor;
    dashLineShapeLayer.lineWidth = 1;
    dashLineShapeLayer.lineDashPattern = @[@(6),@(6)];
    
    dashLineShapeLayer.strokeStart = 0;
    dashLineShapeLayer.strokeEnd = 1;
    dashLineShapeLayer.zPosition = 999;
    [scroll.layer addSublayer:dashLineShapeLayer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeUI];
    [self makeFrame];
}

-(void) makeUI
{
    UILabel * contact = [[UILabel alloc]init];
    contact.textColor = [UIColor blackColor];
    contact.text = @"联系人";
    contact.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:contact];
    _contact = contact;
    UILabel * contactprompt = [[UILabel alloc]init];
    contactprompt.textColor = [UIColor blackColor];
    contactprompt.text = @"(请注意携带身份证)";
    contactprompt.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:contactprompt];
    _contactprompt = contactprompt;
    UILabel * name = [[UILabel alloc]init];
    name.textColor = [UIColor blackColor];
    name.text = @"姓名";
    name.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:name];
    _name = name;
    UILabel * phone = [[UILabel alloc]init];
    phone.textColor = [UIColor blackColor];
    phone.text = @"手机号码";
    phone.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:phone];
    _phone = phone;
    UILabel * note = [[UILabel alloc]init];
    note.textColor = [UIColor blackColor];
    note.text = @"备注";
    note.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:note];
    _note = note;
    UIView * linecontact = [UIView new];
    linecontact.backgroundColor = [UIColor blackColor];
    [self.view addSubview:linecontact];
    _linecontact = linecontact;
    UIView * linename = [UIView new];
    linename.backgroundColor = [UIColor blackColor];
    [self.view addSubview:linename];
    _linename = linename;
    UIView * linephone = [UIView new];
    linephone.backgroundColor = [UIColor blackColor];
    [self.view addSubview:linephone];
    _linephone = linephone;
    UITextField * tfname = [UITextField new];
    tfname.textColor = [UIColor blackColor];
    tfname.font = [UIFont systemFontOfSize:13];
    tfname.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:tfname];
    _tfname = tfname;
    UITextField * tfphone = [UITextField new];
    tfphone.textColor = [UIColor blackColor];
    tfphone.font = [UIFont systemFontOfSize:13];
    tfphone.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:tfphone];
    _tfphone = tfphone;
    XLTextView * txnote = [XLTextView new];
    txnote.font = [UIFont systemFontOfSize:13];
    txnote.placeholder = @"请输入您的特殊要求";
    txnote.textColor = [UIColor blackColor];
    [self.view addSubview:txnote];
    _txnote = txnote;
    UIButton * submit =[[UIButton alloc]init];
    [submit setBackgroundColor:[UIColor blackColor]];
    [submit addTarget:self action:@selector(submitAction) forControlEvents:64];
    [submit setTitleColor:[UIColor whiteColor] forState:0];
    submit.titleLabel.font = [UIFont systemFontOfSize:13];
    [submit setTitle:@"完成订单" forState:0];
    _submit = submit;
}

-(void) makeFrame
{
    self.contact.frame = CGRectMake(20, 330, 50, 18);
    self.contactprompt.frame = CGRectMake(self.contact.viewRightX+2, 333, SCREENWIDTH-self.contact.viewRightX, 18);
    self.linecontact.frame = CGRectMake(20, self.contactprompt.viewBottomY+15, SCREENWIDTH-40, 1);
    self.name.frame = CGRectMake(20, self.linecontact.viewBottomY+15, 90, 16);
    self.tfphone.frame = CGRectMake(self.name.viewRightX, self.linecontact.viewBottomY+15, SCREENWIDTH-self.name.viewRightX, 16);
    self.linename.frame = CGRectMake(20, self.name.viewBottomY+15, SCREENWIDTH-40, 1);
    self.phone.frame = CGRectMake(20, self.linename.viewBottomY+15, 90, 16);
    self.tfname.frame = CGRectMake(self.phone.viewRightX, self.linename.viewBottomY+15, SCREENWIDTH-self.phone.viewRightX, 16);
    self.linephone.frame = CGRectMake(20, self.phone.viewBottomY+15, SCREENWIDTH-40, 1);
    self.note.frame = CGRectMake(20, self.linephone.viewBottomY+30, SCREENWIDTH-40, 18);
    self.txnote.frame = CGRectMake(20, self.note.viewBottomY+15, SCREENWIDTH-40, 144);
    self.submit.frame = CGRectMake(20, self.txnote.viewBottomY+44, SCREENWIDTH-40, 40);
}

-(void) submitAction
{
   
}


@end
