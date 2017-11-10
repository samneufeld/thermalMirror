//
//  pdf.m
//  FLIROneSDKExample
//
//  Created by Sam Neufeld on 11/9/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import "pdf.h"
#import "PDFImageConverter.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface pdf () <MFMailComposeViewControllerDelegate>

@end

@implementation pdf



- (void)viewDidLoad {
    _image0.image=_im0;
    _image1.image=_im1;
    _image2.image=_im2;
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    
    // Save image.
    [UIImagePNGRepresentation(_im0) writeToFile:filePath atomically:YES];
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

@end
