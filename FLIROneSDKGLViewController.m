//
//  FLIROneSDKGLViewController.m
//  FLIROneSDKExampleApp
//
//  Created by Colicchio, Joseph on 7/26/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import "FLIROneSDKGLViewController.h"

#import <FLIROneSDK/FLIROneSDK.h>

@interface FLIROneSDKGLViewController ()

@property (weak, nonatomic) IBOutlet GLKView *glkView;

@end

@implementation FLIROneSDKGLViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // when the view is about to appear, we need to give the glkView to the stream manager
    [FLIROneSDKStreamManager sharedInstance].glkView = self.glkView;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // and when the view is about to disappear, we should set the glkView back to nil
    [FLIROneSDKStreamManager sharedInstance].glkView = nil;
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)imageOptionsButtonPressed:(id)sender {
    switch([FLIROneSDKStreamManager sharedInstance].glkViewImageOptions) {
        case FLIROneSDKImageOptionsBlendedMSXRGBA8888Image:
            [FLIROneSDKStreamManager sharedInstance].glkViewImageOptions = FLIROneSDKImageOptionsVisualYCbCr888Image;
            break;
        case FLIROneSDKImageOptionsVisualYCbCr888Image:
            [FLIROneSDKStreamManager sharedInstance].glkViewImageOptions = FLIROneSDKImageOptionsThermalRGBA8888Image;
            break;
        default:
            [FLIROneSDKStreamManager sharedInstance].glkViewImageOptions = FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
            break;
    }
}

@end
