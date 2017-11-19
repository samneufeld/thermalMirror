//
//  Gallery.m
//  FLIROneSDKExample
//
//  Created by Sam Neufeld on 11/9/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import "Gallery.h"
#import "FLIROneSDKExampleViewController.h"

@interface Gallery ()

@end

@implementation Gallery

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FLIROneSDKImageEditor sharedInstance] addDelegate:self];
    
    //self.imageOptions = FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
    //[[FLIROneSDKImageEditor sharedInstance] setImageOptions:self.imageOptions];
    
    [[FLIROneSDKImageEditor sharedInstance] loadImageWithFilepath:self.filepath];
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

@end
