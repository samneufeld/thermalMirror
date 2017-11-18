//
//  FLIROneSDKEditorViewController.m
//  FLIROneSDKExampleApp
//
//  Created by Colicchio, Joseph on 6/22/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import <FLIROneSDK/FLIROneSDK.h>
#import "FLIROneSDKEditorViewController.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import <MessageUI/MessageUI.h>



@interface FLIROneSDKEditorViewController () <FLIROneSDKImageReceiverDelegate, FLIROneSDKImageEditorDelegate, SKPSMTPMessageDelegate, MFMailComposeViewControllerDelegate>{
    int counter;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;


@property (strong, nonatomic) FLIROneSDKPalette *palette;
@property (nonatomic) CGFloat emissivity;
@property (nonatomic) FLIROneSDKImageOptions imageOptions;

@property (strong, nonatomic) UIImage *renderedImage;
@property (strong, nonatomic) UIImage *renderedImage1;
@property (strong, nonatomic) UIImage *renderedImage2;


@property (nonatomic) BOOL uiEnabled;

@end

@implementation FLIROneSDKEditorViewController

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_emailQuery resignFirstResponder];
    return YES;
}


- (void)sendMessageInBack:(id)anObject{
    NSLog(@"Start Sending");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"tmp.pdf"];
    
    
    NSData *dataObj = [NSData dataWithContentsOfFile:writableDBPath];
    
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = @"";
    testMsg.toEmail = @"";
    testMsg.relayHost = @"smtp.server.com";
    testMsg.requiresAuth = YES;
    testMsg.login = @"";
    testMsg.pass = @"Papercat6967";
    testMsg.subject = @"Some subject";
    testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               @"Some text to include in body",kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    
    /*NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"filenametoshow.pdf\"",kSKPSMTPPartContentTypeKey,
                             @"attachment;\r\n\tfilename=\"filenametoshow.pdf\"",kSKPSMTPPartContentDispositionKey,[dataObj encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];*/
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,
                     //vcfPart,
                     nil];
    
    [testMsg send];
    
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    [message release];
    // open an alert with just an OK button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send email"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}

- (void)messageSent:(SKPSMTPMessage *)message{
    [message release];
    
    NSLog(@"delegate - message sent");
}






























- (void)viewDidLoad {
    _emailQuery.delegate=self;
    _switcher.alpha=0;
    _switcher.enabled=FALSE;
    _switcher.userInteractionEnabled=FALSE;
    _dialog.text=[NSString stringWithFormat:@"%s", "Your thermal image selfies are ready."];
    _yes.enabled=TRUE;
    _no.enabled=TRUE;
    _yes.alpha=1;
    _no.alpha=1;
    _emailQuery.alpha=0;
    _emailQuery.enabled=FALSE;
    _emailQuery.highlighted=FALSE;
    _explo.alpha=1;
    _entryBar.alpha=0;
    _marketText.alpha=0;
    _marketText.enabled=FALSE;
    
    for(int i=0; i<3; i++){
    switch(i){
        case 0:
            // load the thermal image based on url
            [[FLIROneSDKImageEditor sharedInstance] addDelegate:self];
            counter=3;
            
            //self.imageOptions = FLIROneSDKImageOptionsBlendedMSXRGBA8888Image;
            //[[FLIROneSDKImageEditor sharedInstance] setImageOptions:self.imageOptions];
            
            [[FLIROneSDKImageEditor sharedInstance] loadImageWithFilepath:self.filepath];
            break;
        case 1:
            counter=2;
            //[[FLIROneSDKImageEditor sharedInstance] addDelegate:self];
            [[FLIROneSDKImageEditor sharedInstance] loadImageWithFilepath:self.filepath1];
            break;
        case 2:
            counter=1;
            //[[FLIROneSDKImageEditor sharedInstance] addDelegate:self];
            [[FLIROneSDKImageEditor sharedInstance] loadImageWithFilepath:self.filepath2];
            break;
    }
    

    }
    

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.uiEnabled = NO;
    
   
    
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"pdfSegue"]) {
        pdf *editorVC = (pdf *)segue.destinationViewController;
        
        editorVC.im0 = _im0;
        editorVC.im1 = _im1;
        editorVC.im2 = _im2;
        
    }
}
*/
- (void)setUiEnabled:(BOOL)uiEnabled {
    _uiEnabled = uiEnabled;
    [self updateUI];
}

- (void) updateUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.saveButton setEnabled:self.uiEnabled];
        //[self.emissivityButton setEnabled:self.uiEnabled];
        //[self.paletteButton setEnabled:self.uiEnabled];
        _imageView.image=_im0;
        _imageView1.image=_im1;
        _imageView2.image=_im2;

        
        
        
        
/*        [self.paletteButton setTitle:[NSString stringWithFormat:@"Palette: %@", self.palette.name] forState:UIControlStateNormal];

        if(self.imageOptions == FLIROneSDKImageOptionsBlendedMSXRGBA8888Image) {
            [self.renderModeButton setTitle:@"Mode: MSX" forState:UIControlStateNormal];
        }
        else if(self.imageOptions == FLIROneSDKImageOptionsVisualYCbCr888Image) {
            [self.renderModeButton setTitle:@"Mode: YCbCr" forState:UIControlStateNormal];
        }
        else if(self.imageOptions == FLIROneSDKImageOptionsVisualJPEGImage) {
            [self.renderModeButton setTitle:@"Mode: JPEG" forState:UIControlStateNormal];
        }
        else if(self.imageOptions == FLIROneSDKImageOptionsThermalRGBA8888Image) {
            [self.renderModeButton setTitle:@"Mode: Thermal" forState:UIControlStateNormal];
        }
        else if(self.imageOptions == FLIROneSDKImageOptionsThermalLinearFlux14BitImage) {
            [self.renderModeButton setTitle:@"Mode: Thermal Flux" forState:UIControlStateNormal];
        }
        else if(self.imageOptions == FLIROneSDKImageOptionsThermalRadiometricKelvinImage) {
            [self.renderModeButton setTitle:@"Mode: Radiometric" forState:UIControlStateNormal];
        }
        else if(self.imageOptions == FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat) {
            [self.renderModeButton setTitle:@"Mode: Radiometric F" forState:UIControlStateNormal];
        }
 
        [self.emissivityButton setTitle:[NSString stringWithFormat:@"%f", self.emissivity] forState:UIControlStateNormal];
    */});
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)exitButtonPressed:(id)sender {
    [[FLIROneSDKImageEditor sharedInstance] removeDelegate:self];
    [self dismissViewControllerAnimated:YES completion:nil];


}


- (void)FLIROneSDKEditorImageDidFinishLoading:(FLIROneSDKImageIOStatus)loadedStatus {
    self.imageOptions = [[FLIROneSDKImageEditor sharedInstance] imageOptions];
    self.uiEnabled = YES;
    [self updateUI];
}

- (void)FLIROneSDKEditorImageDidFinishSaving:(FLIROneSDKImageIOStatus)savedStatus withFilepath:(NSURL *)filepath {
    //self.uiEnabled = YES;
    
    [[FLIROneSDKImageEditor sharedInstance] loadImageWithFilepath:self.filepath];
    
}
/*
- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveFrameWithOptions:(FLIROneSDKImageOptions)options metadata:(FLIROneSDKImageMetadata *)metadata sequenceNumber:(NSInteger)sequenceNumber{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.msxImageView.image = nil;
        self.visualImageView.image = nil;
        self.irImageView.image = nil;
    });
    
    self.palette = metadata.palette;
    self.emissivity = metadata.emissivity;
    [self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveBlendedMSXRGBA8888Image:(NSData *)msxImage imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber{
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image andData:msxImage andSize:size];
    
    
    self.renderedImage = image;
    //self.renderedImage1 = image1;
    //self.renderedImage2 = image2;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.msxImageView.image = image;
    });
    [self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermalRGBA8888Image:(NSData *)thermalImage imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber{
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRGBA8888Image andData:thermalImage andSize:size];
    self.renderedImage = image;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.irImageView.image = image;
    });
    [self updateUI];
}
*/
- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermal14BitLinearFluxImage:(NSData *)linearFluxImage imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber{
    
    self.renderedImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalLinearFlux14BitImage andData:linearFluxImage andSize:size];
    [self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricData:(NSData *)radiometricData imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber{

    
    self.renderedImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImage andData:radiometricData andSize:size];
    [self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricDataFloat:(NSData *)radiometricData imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber{

    self.renderedImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat andData:radiometricData andSize:size];
    [self updateUI];
}
/*
- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveVisualYCbCr888Image:(NSData *)visualYCbCr888Image imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber{
    
    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsVisualYCbCr888Image andData:visualYCbCr888Image andSize:size];
    self.renderedImage = image;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.visualImageView.image = image;
    });
    [self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveVisualJPEGImage:(NSData *)visualJPEGImage sequenceNumber:(NSInteger)sequenceNumber{

    UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsVisualJPEGImage andData:visualJPEGImage andSize:CGSizeMake(0,0)];
    self.renderedImage = image;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.visualImageView.image = image;
    });
    [self updateUI];
}
*/
- (IBAction)confirm:(id)sender {
    _yes.enabled=FALSE;
    _no.enabled=FALSE;
    _yes.alpha=0;
    _no.alpha=0;
    _emailQuery.alpha=1;
    _emailQuery.enabled=TRUE;
    [_emailQuery becomeFirstResponder];
    _dialog.text=[NSString stringWithFormat:@"%s", "Your thermal image selfies will be sent to your inbox."];
    _explo.alpha=0;
    _entryBar.alpha=1;
    _switcher.alpha=1;
    _switcher.enabled=TRUE;
    _switcher.userInteractionEnabled=TRUE;
    _marketText.alpha=1;
    _marketText.enabled=TRUE;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            //Email sent
            break;
        case MFMailComposeResultSaved:
            //Email saved
            break;
        case MFMailComposeResultCancelled:
            //Handle cancelling of the email
            break;
        case MFMailComposeResultFailed:
            //Handle failure to send.
            break;
        default:
            //A failure occurred while completing the email
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deny:(id)sender {
}

- (IBAction)toggle:(id)sender {

}
- (IBAction)emailer:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail =
        [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Your Ministry of Supply Thermal Selfies"];
        //[mail setMessageBody:@" isHTML:NO];
        NSArray *array = @[];
        if (_switcher.on==FALSE){
            array = @[_emailQuery.text];
        } else {
            array = @[@"samneufeld96@gmail.com", _emailQuery.text];
        }
        [mail setToRecipients:array];
        
        NSData *data = UIImagePNGRepresentation(_im0);
        [mail addAttachmentData:data  mimeType:@"image/png" fileName:@"Front"];
        
        NSData *data1 = UIImagePNGRepresentation(_im1);
        [mail addAttachmentData:data1  mimeType:@"image/png" fileName:@"Back"];
        
        NSData *data2 = UIImagePNGRepresentation(_im2);
        [mail addAttachmentData:data2  mimeType:@"image/png" fileName:@"Side"];
        
        
        [self presentViewController:mail animated:YES completion:NULL];
        } else {
            NSLog(@"This device cannot send email");
        }
    
}
@end
