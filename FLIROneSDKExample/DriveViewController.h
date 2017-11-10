//
//  DriveViewController.h
//  HeatSig
//
//  Created by Sam Neufeld on 11/7/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRDrive.h>

@interface DriveViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic, strong) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRDriveService *service;


@end
