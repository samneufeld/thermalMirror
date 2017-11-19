//
//  ViewController.h
//  QuickstartApp
//
//  Created by Sam Neufeld on 11/7/17.
//  Copyright © 2017 Ministry of Supply. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRDrive.h>

@interface ViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRDriveService *service;


@end
