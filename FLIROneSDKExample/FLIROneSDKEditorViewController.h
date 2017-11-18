//
//  FLIROneSDKEditorViewController.h
//  FLIROneSDKExampleApp
//
//  Created by Colicchio, Joseph on 6/22/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLIROneSDKEditorViewController : UIViewController <UITextFieldDelegate>;

@property (strong, nonatomic) IBOutlet UITextField *emailQuery;
@property (strong, nonatomic) NSURL *filepath;
@property (strong, nonatomic) NSURL *filepath1;
@property (strong, nonatomic) NSURL *filepath2;
@property (strong, nonatomic) NSURL *url0;
@property (strong, nonatomic) NSURL *url1;
@property (strong, nonatomic) NSURL *url2;
@property (strong, nonatomic) UIImage *im0;
@property (strong, nonatomic) UIImage *im1;
@property (strong, nonatomic) UIImage *im2;
@property (strong, nonatomic) IBOutlet UIButton *yes;
@property (strong, nonatomic) IBOutlet UIButton *no;
@property (strong, nonatomic) IBOutlet UILabel *explo;
@property (strong, nonatomic) IBOutlet UIImageView *entryBar;
@property (strong, nonatomic) IBOutlet UISwitch *switcher;
@property (strong, nonatomic) IBOutlet UILabel *marketText;
- (IBAction)emailer:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *dialog;
- (IBAction)confirm:(id)sender;
- (IBAction)deny:(id)sender;
- (IBAction)toggle:(id)sender;


@end
