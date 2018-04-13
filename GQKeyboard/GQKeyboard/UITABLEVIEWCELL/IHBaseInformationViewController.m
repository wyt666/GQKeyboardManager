//
//  IHBaseInformationViewController.m
//  iHome
//
//  Created by zzz on 16/6/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "IHBaseInformationViewController.h"
#import "IHBaseInformationCell.h"
#import "IHBaseInformationModel.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface IHBaseInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)UITapGestureRecognizer * tap ;
@end

@implementation IHBaseInformationViewController
{
    NSArray * _imageArr;
    NSArray * _titleArr;
    NSMutableArray * _title_numArr;

    UITextField * _editTextField;
    float _originalOffsetY;
    float _originaloffsizeY;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.title = @"基本信息";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _imageArr = @[@"pencil",@"pencil",@"pencil",@"pencil",@"pencil",@"pencil",@"pencil",@"pencil",@"pencil",@"pencil",@"pencil",@"pencil"];
    _titleArr = @[@"中文名字",@"姓(英文/拼音)",@"名(英文/拼音)",@"出生日期",@"所属单位",@"中文名字",@"姓(英文/拼音)",@"名(英文/拼音)",@"出生日期",@"所属单位",@"中文名字",@"姓(英文/拼音)",@"名(英文/拼音)",@"出生日期",@"所属单位"];
    _title_numArr = [NSMutableArray arrayWithCapacity:5];
    _title_numArr = @[@"西欧爱霞",@"xiou",@"aixia",@"1999-01-01",@"牛气",@"西欧爱霞",@"xiou",@"aixia",@"1999-01-01",@"牛气",@"西欧爱霞",@"xiou",@"aixia",@"1999-01-01",@"牛气"];
    
    [self loadData];
    [self makeTableView];
    [self makeTableViewHeader];
}

- (void)loadData{
    [_dataArr removeAllObjects];
    for (int i = 0; i < 2; i++) {
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
        if (i==0) {
            for (int j=0; j<12; j++) {
                IHBaseInformationModel * model = [[IHBaseInformationModel alloc]init];
                model.image1 = _imageArr[j];
                model.title1 = _titleArr[j];
                model.title2 = _title_numArr[j];
                [arr addObject:model];
            }
        } else {
            for (int j= 0 ; j<1; j++) {
                IHBaseInformationModel * model = [[IHBaseInformationModel alloc]init];
                model.title1 = _titleArr[4];
                model.title2 = _title_numArr[4];
                [arr addObject:model];
            }
        }
        [_dataArr addObject:arr];
    }
    [_tableView reloadData];
}

- (void)makeTableViewHeader{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 149)];
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-6, 149)];
    imageView1.backgroundColor = [UIColor blueColor];
    [view addSubview:imageView1];
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageView1.frame)/2.0-93/2.0, 12, 93, 93)];
    imageView2.image=[UIImage imageNamed:@"头像"];
    [view addSubview:imageView2];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView2.frame)+3, SCREENWIDTH-6, 16)];
    label1.text = @"西欧爱霞";
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];

    float width = [self sizeWithString:label1.text fount:label1.font maxSize:CGSizeMake(SCREENWIDTH-80, 16)].width +5;
    UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width/2.0+width/2.0, CGRectGetMaxY(label1.frame)-32, 31, 31)];
    imageView3.image = [UIImage imageNamed:@"huangguan"];
    [view addSubview:imageView3];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+6, SCREENWIDTH-6, 14)];
    label2.text = @"距离您升级为银卡会员还有30分";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label2.text];
    NSRange redRange2=NSMakeRange([[attributedString string] rangeOfString:@"距离您升级为银卡会员还有"].location, [[attributedString string] rangeOfString:@"距离您升级为银卡会员还有"].length);
    NSRange redRange3=NSMakeRange(redRange2.location +redRange2.length, label2.text.length-13);
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:redRange3];
    label2.attributedText = attributedString;
    _tableView.tableHeaderView = view;
}


- (void)makeTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 0, SCREENWIDTH-6, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTableView:)];
    [_tableView addGestureRecognizer:tap];
    _tap = tap;
    _tap.enabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerNib:[UINib nibWithNibName:@"IHBaseInformationCell" bundle:nil] forCellReuseIdentifier:@"IHBaseInformationCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return [_dataArr[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IHBaseInformationCell * cell = (IHBaseInformationCell *)[tableView dequeueReusableCellWithIdentifier:@"IHBaseInformationCell"];

    cell.beginEditBlock = ^(UITextField * textField){
        _editTextField = textField;
    } ;
    cell.endEditBlock =^(UITextField * textField){
        _editTextField = nil;
    } ;

    cell.model = _dataArr[indexPath.section][indexPath.row];

    cell.textField1.rightViewMode=UITextFieldViewModeAlways;
    
    if (indexPath.section == 1) {
        cell.textField1.rightViewMode=UITextFieldViewModeNever;
    }
 
    cell.line1.hidden = NO;
   
    if (indexPath.row == [_dataArr[indexPath.section] count]-1) {
        cell.line1.hidden = YES;
      
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
  
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGSize)sizeWithString:(NSString *)str
                  fount:(UIFont*)fount
                maxSize:(CGSize)size {
    
    CGRect rect = [str boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                 attributes:@{NSFontAttributeName:fount}
                                    context:nil];
    return rect.size;
}

- (void)tapTableView:(UITapGestureRecognizer *)tap{
    if (_editTextField) {
        [_editTextField resignFirstResponder];
    }
}

@end
