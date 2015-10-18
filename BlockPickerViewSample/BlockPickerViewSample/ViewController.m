//
//  ViewController.m
//  BlockPickerViewSample
//
//  Created by zhujinhui on 15/10/4.
//  Copyright © 2015年 kyson. All rights reserved.
//

#import "ViewController.h"
#import "KSBlockPickerView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,KSBlockPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *titles = @[@"Show(signal selection enable)",@"Show(multi selection enable)"];
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *data = @[   @{@"静安":@[@"不限",@"北京西路",@"曹家渡",@"江宁路",@"南京西路",@"玉佛寺"]},
                         @{@"徐汇":@[@"不限",@"徐家汇",@"交通大学",@"枫林路",@"上海南站",@"田林"]},
                         @{@"浦东":@[@"不限",@"张江",@"三林",@"世博滨江",@"洋泾",@"陆家嘴"]},
                         @{@"卢湾":@[@"不限",@"淮海中路",@"鲁班路",@"五里桥",@"新天地",@"复兴公园"]},
                         @{@"普陀":@[@"不限",@"武宁",@"华东师大",@"李子园",@"真如",@"宜川路"]}
                         ];
    KSBlockPickerView *pickerView = nil;
    switch (indexPath.row) {
        case 0:{
            pickerView = [[KSBlockPickerView alloc] initWithData:data multiDistrictsSelectEnable:NO];

        }
            break;
        case 1:{
            pickerView = [[KSBlockPickerView alloc] initWithData:data multiDistrictsSelectEnable:YES];

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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"show" message:resultString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
