//
//  BlockPickerInputViewController.m
//  BlockPickerViewSample
//
//  Created by zhujinhui on 15/11/7.
//  Copyright © 2015年 kyson. All rights reserved.
//

#import "BlockPickerInputViewController.h"

@interface BlockPickerInputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *leftRowIndexTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightRowIndexTextField;

@end

@implementation BlockPickerInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#define KSTextIsNull(text) (nil == text || [text isEqualToString:@""])

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)confirmButtonClicked:(id)sender {
    if (KSTextIsNull(_leftRowIndexTextField.text) || KSTextIsNull(_rightRowIndexTextField.text)) {
        NSString *resultString = [NSString stringWithFormat:@"Please intput text"];
#ifdef __IPHONE_9_0
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"I know" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"show" message:resultString preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:action];
        [self presentViewController:alertView animated:YES completion:nil];
#else
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"show" message:resultString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
#endif
    }else{
        if (self.blockPickerInputViewRowIndexSelectedBlock) {
            self.blockPickerInputViewRowIndexSelectedBlock(_leftRowIndexTextField.text,_rightRowIndexTextField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
    
    
    
    
}




@end
