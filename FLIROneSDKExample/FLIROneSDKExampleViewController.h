//
//  FLIROneSDKExampleViewController.h
//  FLIROneSDKExample
//
//  Created by Joseph Colicchio on 5/22/14.
//  Copyright (c) 2014 novacoast. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <FLIROneSDK/FLIROneSDK.h>
//#import <FlirOneFramework/FLIROne.h>

@interface FLIROneSDKExampleViewController : UIViewController <FLIROneSDKImageReceiverDelegate, FLIROneSDKStreamManagerDelegate, FLIROneSDKVideoRendererDelegate, FLIROneSDKImageEditorDelegate>
   

//@interface FLIROneSDKExampleViewController : UIViewController <FLIROneDeviceDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *frontImage;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *sideImage;
- (IBAction)start:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *timerLab;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBar;
@property (strong, nonatomic) IBOutlet UIImageView *flasher;
@property (strong, nonatomic) IBOutlet UIButton *edit1Button;
@property (strong, nonatomic) IBOutlet UIImageView *imageSide;
@property (strong, nonatomic) IBOutlet UIImageView *imageBack;
@property (strong, nonatomic) IBOutlet UIImageView *imageFront;
@property (strong, nonatomic) IBOutlet UILabel *expo;
@property (strong, nonatomic) IBOutlet UIButton *settings;
@property (strong, nonatomic) IBOutlet UILabel *successMessage;
@property (strong, nonatomic) IBOutlet UIButton *restartButton;

@end
