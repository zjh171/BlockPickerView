//
//  BlockPickerInputViewController.h
//  BlockPickerViewSample
//
//  Created by zhujinhui on 15/11/7.
//  Copyright © 2015年 kyson. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^BlockPickerInputViewRowIndexSelectedBlock)(NSString *leftRowIndex,NSString *rightRowIndex ) ;

@interface BlockPickerInputViewController : UIViewController


@property (nonatomic, copy) BlockPickerInputViewRowIndexSelectedBlock blockPickerInputViewRowIndexSelectedBlock;

@end
