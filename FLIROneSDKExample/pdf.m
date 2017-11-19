//
//  pdf.m
//  FLIROneSDKExample
//
//  Created by Sam Neufeld on 11/9/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import "pdf.h"

/*#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"*/


@interface pdf () //<SKPSMTPMessageDelegate>;
@end



@implementation pdf



- (void)viewDidLoad {
    _image0.image=_im0;
    _image1.image=_im1;
    _image2.image=_im2;
    
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

- (IBAction)button:(id)sender {
    //[self sendMessageInBack:_image0.image];
}
@end
