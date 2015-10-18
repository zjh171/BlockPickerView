//
//  KSBlockPickerView.h
//  Angejia
//
//  Created by zhujinhui on 15/10/2.
//  Copyright © 2015年 http://kyson.cn All rights reserved.
//



#import <UIKit/UIKit.h>
/**
 *  You can initial pickerview with "initWithData:(NSArray *) data multiDistrictsSelectEnable:"
 
 * data are like this: @[   @{@"静安":@[@"不限",@"北京西路",@"曹家渡",@"江宁路",@"南京西路",@"玉佛寺"]},
 @{@"徐汇":@[@"不限",@"徐家汇",@"交通大学",@"枫林路",@"上海南站",@"田林"]},
 @{@"浦东":@[@"不限",@"张江",@"三林",@"世博滨江",@"洋泾",@"陆家嘴"]},
 @{@"卢湾":@[@"不限",@"淮海中路",@"鲁班路",@"五里桥",@"新天地",@"复兴公园"]},
 @{@"普陀":@[@"不限",@"武宁",@"华东师大",@"李子园",@"真如",@"宜川路"]}
 ];
 
 * As you known,data is arrray contains dictionary,every dictionary contains district and blocks belong it
 * if you set the first element as "不限",it will select all blocks belong the district...
 * but it also work if you don't set it ,it means you can set data like this:
 *
 @[   @{@"静安":@[@"北京西路",@"曹家渡",@"江宁路",@"南京西路",@"玉佛寺"]},
 ];
 
 * see more at http://kyson.cn/index.php/archives/16/
 */


@protocol KSBlockPickerViewDelegate;

@interface KSBlockPickerView : UIView
/**
 * whether left tableview enable multiselect
 */
@property (nonatomic, assign,readonly) BOOL multiDistrictsSelectEnable;

@property (nonatomic, weak) id<KSBlockPickerViewDelegate> delegate;
/**
 *      @{    @0:@[@1,@2],
              @1:@[@2,@3],
        }
 */
@property (nonatomic, strong) NSDictionary *selectedRows;

/**
 * After setting data,please call method "reloadData" ...
 */
@property (nonatomic, strong) NSArray *data;

-(instancetype) initWithData:(NSArray *) data multiDistrictsSelectEnable:(BOOL) enable;

-(void)reloadData;

-(void)show;

-(void)remove;

@end


@protocol KSBlockPickerViewDelegate <NSObject>
/**
 * left row enable multiselected
 * rows are like
 * @{@0:@[@1,@2]}   ->Means left tableview selected row 0, right tableview selected row 1 and row 2.
 */
-(void)blockPickerView:(KSBlockPickerView *) pickerView selectedRows:(NSDictionary *) rows;

@end
