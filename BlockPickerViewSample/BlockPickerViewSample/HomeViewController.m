//
//  ViewController.m
//  BlockPickerViewSample
//
//  Created by zhujinhui on 15/10/4.
//  Copyright © 2015年 kyson. All rights reserved.
//

#import "HomeViewController.h"
#import "KSBlockPickerView.h"
#import "BlockPickerInputViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,KSBlockPickerViewDelegate>{
    NSArray *titles;
    
    NSArray *data;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    titles = @[@"Show(signal selection enable)",@"Show(multi selection enable)",@"set selected rows"];
    
    data = @[   @{@"静安":@[@"不限",@"北京西路",@"曹家渡",@"江宁路",@"南京西路",@"玉佛寺"]},
                         @{@"徐汇":@[@"不限",@"徐家汇",@"交通大学",@"枫林路",@"上海南站",@"田林"]},
                         @{@"浦东":@[@"不限",@"张江",@"三林",@"世博滨江",@"洋泾",@"陆家嘴"]},
                         @{@"卢湾":@[@"不限",@"淮海中路",@"鲁班路",@"五里桥",@"新天地",@"复兴公园"]},
                         @{@"普陀":@[@"不限",@"武宁",@"华东师大",@"李子园",@"真如",@"宜川路"]}
                         ];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KSBlockPickerView *pickerView = nil;
    switch (indexPath.row) {
        case 0:{
            pickerView = [[KSBlockPickerView alloc] initWithData:data multiDistrictsSelectEnable:NO];

        }
            break;
        case 1:{
            pickerView = [[KSBlockPickerView alloc] initWithData:data multiDistrictsSelectEnable:YES];

        }
        case 2:{
            BlockPickerInputViewController *blockViewController = [[BlockPickerInputViewController alloc] init];
            blockViewController.blockPickerInputViewRowIndexSelectedBlock = ^(NSString *left,NSString *right){
                NSNumber *leftNumber = [NSNumber numberWithInteger:left.integerValue];
                NSNumber *rightNumber = [NSNumber numberWithInteger:right.integerValue];

                NSDictionary *dic = @{leftNumber:@[rightNumber]};
                KSBlockPickerView *pickerView1 = [[KSBlockPickerView alloc] initWithData:data multiDistrictsSelectEnable:NO];
                pickerView1.selectedRows = dic;
                [pickerView1 show];
                
            };
            [self.navigationController pushViewController:blockViewController animated:YES];
        }
            
        default:
            break;
    }
    
    pickerView.delegate = self;
    [pickerView show];
}

/**
 *      @{      @0:@[@1,@2],
                @1:@[@2,@3],
 }
 */
-(void)blockPickerView:(KSBlockPickerView *) pickerView selectedRows:(NSDictionary *) rows{
    
    NSMutableString *allRowsString = [[NSMutableString alloc] init];
    for (NSNumber *rowItem in rows.allKeys) {
        NSMutableString *rowsString = [[NSMutableString alloc] init];
        [rowsString appendFormat:@"%@: ",rowItem];
        
        NSArray *rightRows = rows[rowItem];
        for (NSNumber *rightRowItem in rightRows) {
            [rowsString appendFormat:@"%@,",rightRowItem];
        }
        
        NSInteger index = [rows.allKeys indexOfObject:rowItem];
        if (index != rows.allKeys.count - 1) {
            [allRowsString appendFormat:@"%@\n",rowsString];
        }else{
            [allRowsString appendFormat:@"%@",rowsString];
        }
        
    }
    
    NSString *resultString = [NSString stringWithFormat:@"you selected:\n %@",allRowsString];

#ifdef __IPHONE_9_0
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"I know" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"show" message:resultString preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:action];
    [self presentViewController:alertView animated:YES completion:nil];
#else
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"show" message:resultString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
#endif
    [pickerView remove];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
