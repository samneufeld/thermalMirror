//
//  mainController.h
//  FLIROneSDKExample
//
//  Created by Sam Neufeld on 11/6/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *fName;
@property (strong, nonatomic) IBOutlet UITextField *lName;
@property (strong, nonatomic) IBOutlet UITextField *eMail;


@end
