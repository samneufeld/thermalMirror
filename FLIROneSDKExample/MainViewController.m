//
//  mainController.m
//  FLIROneSDKExample
//
//  Created by Sam Neufeld on 11/6/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import "MainViewController.h"

@interface mainController ()

@end

@implementation mainController
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_fName resignFirstResponder];
    [_lName resignFirstResponder];
    [_eMail resignFirstResponder];
    return YES;
}
- (void)viewDidLoad {
    _fName.delegate=self;
    _lName.delegate=self;
    _eMail.delegate=self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fname:(id)sender {
}

- (IBAction)lname:(id)sender {
}

- (IBAction)email:(id)sender {
}
- (IBAction)fName:(id)sender {
}
- (IBAction)e:(UITextField *)sender {
}
@end
