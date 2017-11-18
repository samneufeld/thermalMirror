//
//  FLIROneSDKExampleViewController.m
//  FLIROneSDKExample
//
//  Created by Joseph Colicchio on 5/22/14.
//  Copyright (c) 2014 novacoast. All rights reserved.
//

#import "FLIROneSDKExampleViewController.h"
#import "FLIROneSDKEditorViewController.h"
#import "Gallery.h"
#import "pdf.h"


//#import <FLIROneSDK/FLIROneSDKLibraryViewController.h>

#import <AVFoundation/AVFoundation.h>

#import <FLIROneSDK/FLIROneSDKUIImage.h>

#import <FLIROneSDK/FLIROneSDKSimulation.h>

@interface FLIROneSDKExampleViewController (){
int timeTick;
int photoID;
int timerLength;
NSURL *photoURL0;
NSURL *photoURL1;
NSURL *photoURL2;
NSTimer *timer;
UIImage *img0;
UIImage *img1;
UIImage *img2;
}
//The main viewfinder for the FLIR ONE
@property (weak, nonatomic) IBOutlet UIView *masterImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thermalImageView;
@property (strong, nonatomic) IBOutlet UIImageView *radiometricImageView;
@property (strong, nonatomic) IBOutlet UIImageView *visualJPEGView;
@property (strong, nonatomic) IBOutlet UIImageView *visualYCbCrView;

@property (strong, nonatomic) IBOutlet UIButton *thermalButton;
@property (strong, nonatomic) IBOutlet UIButton *thermal14BitButton;
@property (strong, nonatomic) IBOutlet UIButton *visualJPEGButton;
@property (strong, nonatomic) IBOutlet UIButton *visualYCbCrButton;

//labels outlining various camera information
@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *tuningStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *batteryChargingLabel;
@property (strong, nonatomic) IBOutlet UILabel *batteryPercentageLabel;

@property (strong, nonatomic) IBOutlet UILabel *frameCountLabel;

@property (strong, nonatomic) IBOutlet UIButton *paletteButton;

@property (strong, nonatomic) IBOutlet UIButton *emissivityButton;
@property (strong, nonatomic) IBOutlet UIButton *msxButton;
@property (strong, nonatomic) IBOutlet UIButton *tuneButton;
@property (strong, nonatomic) IBOutlet UISwitch *autoTuneSwitch;
@property (weak, nonatomic) IBOutlet UIButton *spanLockButton;
@property (strong, nonatomic) UIView *regionView;
@property (strong, nonatomic) UILabel *regionMinLabel;
@property (strong, nonatomic) UILabel *regionMaxLabel;
@property (strong, nonatomic) UILabel *regionAverageLabel;

@property (strong, nonatomic) UIView *hottestPoint;
@property (strong, nonatomic) UILabel *hottestLabel;
@property (strong, nonatomic) UIView *coldestPoint;
@property (strong, nonatomic) UILabel *coldestLabel;

@property (strong, nonatomic) NSData *thermalData;
@property (nonatomic) CGSize thermalSize;
@property (nonatomic) BOOL thermalDataIsFloats;

//buttons for interacting with the FLIR ONE
//view library
@property (nonatomic, strong) IBOutlet UIButton *editButton;
//capture photo
@property (nonatomic, strong) IBOutlet UIButton *capturePhotoButton;
//capture video
@property (nonatomic, strong) IBOutlet UIButton *captureVideoButton;
//swap palettes, button overlays the viewfinder
//@property (nonatomic, strong) UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *vividIRButton;

//data for UI to display
@property (strong, nonatomic) UIImage *thermalImage;
@property (strong, nonatomic) UIImage *radiometricImage;
@property (strong, nonatomic) UIImage *visualJPEGImage;
@property (strong, nonatomic) UIImage *visualYCbCrImage;

//@property (strong, nonatomic) FLIROneSDKUIImage *sdkImage;

@property (strong, nonatomic) NSDictionary *spotTemperatures;
@property (strong, nonatomic) FLIROneSDKPalette *palette;
@property (nonatomic) NSUInteger paletteCount;

@property (nonatomic) BOOL connected;
@property (nonatomic) BOOL isDongle;
@property (nonatomic) BOOL isGen3Dongle;
@property (nonatomic) BOOL isProDongle;

@property (nonatomic) FLIROneSDKTuningState tuningState;

@property (nonatomic) FLIROneSDKBatteryChargingState batteryChargingState;
@property (nonatomic) NSInteger batteryPercentage;

//@property (nonatomic) FLIROneSDKEmissivity *emissivity;
@property (nonatomic) CGFloat emissivity;
@property (nonatomic) FLIROneSDKImageOptions options;

//@property (nonatomic) BOOL pixelDataExists;
@property (nonatomic) CGPoint pixelOfInterest;
@property (nonatomic) CGPoint coldPixel;
@property (nonatomic) CGFloat pixelTemperature;
@property (nonatomic) CGFloat coldestTemperature;

//@property (nonatomic) BOOL regionDataExists;
@property (nonatomic) CGRect regionOfInterest;
@property (nonatomic) CGFloat regionMinTemperature;
@property (nonatomic) CGFloat regionMaxTemperature;
@property (nonatomic) CGFloat regionAverageTemperature;

@property (nonatomic) BOOL msxDistanceEnabled;

@property (strong, nonatomic) dispatch_queue_t renderQueue;
//@property (strong, nonatomic) NSData *imageData;

@property (nonatomic) NSTimeInterval lastTime;
@property (nonatomic) CGFloat fps;

//capturing video stuff

//if the user is capturing a video or in the process of recording, the camera is "busy", block requests to capture more media
@property (nonatomic) BOOL cameraBusy;

@property (strong, nonatomic) NSURL *lastCapturePath;

//if there is currently a video being recorded
@property (nonatomic) BOOL currentlyRecording;
//is the image finished recording, and currently wrapping up the file write process?
@property (nonatomic) BOOL savingVideo;

@property (nonatomic) NSInteger frameCount;

@end

@implementation FLIROneSDKExampleViewController

- (void)viewDidLoad
{
    timerLength=1;
    
    [super viewDidLoad];

    
    //UI stuff
    self.thermalImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.radiometricImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.visualJPEGView.contentMode = UIViewContentModeScaleAspectFit;
    self.visualYCbCrView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.regionView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionView];
    self.regionView.backgroundColor = [UIColor greenColor];
    self.regionView.alpha = 0.5;
    
    self.regionMinLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionMinLabel];
    self.regionMaxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionMaxLabel];
    self.regionAverageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.regionAverageLabel];
    
    self.hottestPoint = [[UIView alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.hottestPoint];
    self.hottestPoint.backgroundColor = [UIColor redColor];
    self.hottestPoint.alpha = 0.5;
    self.hottestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.hottestLabel];
    
    self.coldestPoint = [[UIView alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.coldestPoint];
    self.coldestPoint.backgroundColor = [UIColor blueColor];
    self.coldestPoint.alpha = 0.5;
    self.coldestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.masterImageView addSubview:self.coldestLabel];
    
    //center of screen, half width half height, offset by width/4, height/4
    self.regionOfInterest = CGRectMake(0.25, 0.25, 0.5, 0.5);
    
    //create a queue for rendering
    self.renderQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //set the options to MSX blended
    self.options = FLIROneSDKImageOptionsThermalRGBA8888Image;
    
    [[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
    
    
    self.lastCapturePath = nil;
    
    self.cameraBusy = NO;
    
    self.paletteCount = 0;
    
    [self updateUI];
}


- (UIImage *)captureView {
    
    //hide controls if needed
    CGRect rect = [self.view bounds];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}


- (void)viewDidAppear:(BOOL)animated {
    _startButton.enabled=YES;
    _startButton.alpha=1;
    _restartButton.enabled=NO;
    _restartButton.alpha=0;
    _successMessage.alpha=0;
    _flasher.highlighted=NO;
    _imageBack.alpha=1;
    _imageFront.alpha=1;
    _imageSide.alpha=1;
    _settings.alpha=1;
    _expo.alpha=1;
    _edit1Button.enabled=FALSE;
    _edit1Button.alpha=0;
    _frontImage.highlighted=FALSE;
    _backImage.highlighted=FALSE;
    _sideImage.highlighted=FALSE;
    timeTick=timerLength+1;
    photoID=0;
    [super viewDidAppear:animated];
    
    [[FLIROneSDKStreamManager sharedInstance] setImageOptions:self.options];
    [[FLIROneSDKStreamManager sharedInstance] setFrameDropEnabled:NO];
}

- (IBAction) switchPalette:(UIButton *)button {
    NSInteger paletteIndex = [[[FLIROneSDKPalette palettes] allValues] indexOfObject:self.palette];
    if(paletteIndex >= 0 && paletteIndex < [[[FLIROneSDKPalette palettes] allValues] count]) {
        self.paletteCount = paletteIndex;
    }
    else {
        self.paletteCount = 0;
    }
    self.paletteCount = ((self.paletteCount+1) % [[FLIROneSDKPalette palettes] count]);
    FLIROneSDKPalette *palette = [[[FLIROneSDKPalette palettes] allValues] objectAtIndex:self.paletteCount];
    
    [[FLIROneSDKStreamManager sharedInstance] setPalette:palette];
}

- (void) updateUI {
    //updates the UI based on the state of the sled
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.thermalImageView setImage:self.thermalImage];
        [self.radiometricImageView setImage:self.radiometricImage];
        [self.visualJPEGView setImage:self.visualJPEGImage];
        [self.visualYCbCrView setImage:self.visualYCbCrImage];
        
        if(self.thermalData && self.options & (FLIROneSDKImageOptionsThermalRadiometricKelvinImage | FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat)) {
            //find hottest point
            //self.hottestPoint.hidden = NO;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                @synchronized(self) {
                    [self performTemperatureCalculationsFloat:self.thermalDataIsFloats];
                }
                
                //self.pixelDataExists = true;
                //self.regionDataExists = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update the positions of the hottest, coldest, and temperature region views/labels
                    CGSize imageSize = self.radiometricImageView.frame.size;
                    CGPoint imageOrigin = self.radiometricImageView.frame.origin;
                    
                    CGRect frame;
                    CGFloat size = 30;
                    frame.origin.x = imageOrigin.x + imageSize.width*self.pixelOfInterest.x - size/2.0;
                    frame.origin.y = imageOrigin.y + imageSize.height*self.pixelOfInterest.y - size/2.0;
                    frame.size.width = size;
                    frame.size.height = size;
                    self.hottestPoint.frame = frame;
                    frame.size.width = 100;
                    self.hottestLabel.frame = frame;
                    self.hottestLabel.text = [NSString stringWithFormat:@"%0.2fºC", self.pixelTemperature-273.15];
                    
                    frame = CGRectZero;
                    size = 30;
                    frame.origin.x = imageOrigin.x + imageSize.width * self.coldPixel.x - size/2.0;
                    frame.origin.y = imageOrigin.y + imageSize.height * self.coldPixel.y - size/2.0;
                    frame.size.width = size;
                    frame.size.height = size;
                    self.coldestPoint.frame = frame;
                    frame.size.width = 100;
                    self.coldestLabel.frame = frame;
                    self.coldestLabel.text = [NSString stringWithFormat:@"%0.2fºC", self.coldestTemperature-273.15];
                
                    frame.origin.x = imageOrigin.x + imageSize.width*self.regionOfInterest.origin.x;
                    frame.origin.y = imageOrigin.y + imageSize.height*self.regionOfInterest.origin.y;
                    frame.size.width = imageSize.width*self.regionOfInterest.size.width;
                    frame.size.height = imageSize.height*self.regionOfInterest.size.height;
                    self.regionView.frame = frame;
                    frame.size.width = 100;
                    frame.size.height = 30;
                    self.regionMinLabel.frame = frame;
                    frame.origin.y += 30;
                    self.regionAverageLabel.frame = frame;
                    frame.origin.y += 30;
                    self.regionMaxLabel.frame = frame;
                });
                
                
            });
            
            
        } else {
            //self.pixelDataExists = false;
            //self.regionDataExists = false;
            
            self.hottestLabel.text = @"";
            self.hottestPoint.frame = CGRectZero;
            self.coldestLabel.frame = CGRectZero;
            self.coldestPoint.frame = CGRectZero;
            self.regionMaxLabel.text = @"";
            self.regionMinLabel.text = @"";
            self.regionAverageLabel.text = @"";
            self.regionView.frame = CGRectZero;
            self.regionMaxLabel.frame = CGRectZero;
            self.regionMinLabel.frame = CGRectZero;
            self.regionAverageLabel.frame = CGRectZero;
        }
        
        if(self.palette)
            [self.paletteButton setTitle:[NSString stringWithFormat:@"%@", [self.palette name]] forState:UIControlStateNormal];
        else
            [self.paletteButton setTitle:@"N/A" forState:UIControlStateNormal];
        
        if(self.connected) {
            if(self.isProDongle) {
                [self.connectionLabel setText:@"Gen 3 Pro"];
            }
            else if(self.isGen3Dongle) {
                [self.connectionLabel setText:@"Gen 3 Consumer"];
            }
            else if(self.isDongle) {
                [self.connectionLabel setText:@"Gen 2"];
            }
            else {
                [self.connectionLabel setText:@"Sled"];
            }
            
            [self.capturePhotoButton setEnabled:!self.cameraBusy];
            [self.captureVideoButton setEnabled:(!self.cameraBusy || self.currentlyRecording)];
            [self.spanLockButton setEnabled:YES];
        } else {
            [self.connectionLabel setText:@"Disconnected"];
            [self.capturePhotoButton setEnabled:NO];
            [self.captureVideoButton setEnabled:NO];
            [self.spanLockButton setEnabled:NO];
        }
        
        if([FLIROneSDKStreamManager sharedInstance].spanLockEnabled) {
            [self.spanLockButton setTitle:@"Span Lock: On" forState:UIControlStateNormal];
        }
        else {
            [self.spanLockButton setTitle:@"Span Lock: Off" forState:UIControlStateNormal];
        }
        
        NSString *tuningStateString;
        switch(self.tuningState) {
            case FLIROneSDKTuningStateTuningSuggested:
                tuningStateString = @"Tuning Suggested";
                break;
            case FLIROneSDKTuningStateInProgress:
                tuningStateString = @"Tuning Progress";
                break;
            case FLIROneSDKTuningStateUnknown:
                tuningStateString = @"Tuning Unknown";
                break;
            case FLIROneSDKTuningStateTunedWithClosedShutter:
                tuningStateString = @"Tuned Closed";
                break;
            case FLIROneSDKTuningStateTunedWithOpenedShutter:
                tuningStateString = @"Tuned Open";
                break;
            case FLIROneSDKTuningStateTuningRequired:
                tuningStateString = @"Tuning Required";
                break;
            case FLIROneSDKTuningStateApproximatelyTunedWithOpenedShutter:
                tuningStateString = @"Tuned Approx.";
                break;
        }
        [self.tuningStateLabel setText:[NSString stringWithFormat:@"%@", tuningStateString]];
        
        [self.versionLabel setText:[FLIROneSDK version]];
        
        [self.batteryPercentageLabel setText:[NSString stringWithFormat:@"Battery: %ld%%", (long)self.batteryPercentage]];
        
        
        NSString *chargingState;
        switch(self.batteryChargingState) {
            case FLIROneSDKBatteryChargingStateCharging:
                chargingState = @"Yes";
                break;
            case FLIROneSDKBatteryChargingStateDischarging:
                chargingState = @"No";
                break;
                
            case FLIROneSDKBatteryChargingStateError:
                chargingState = @"Err";
                break;
            case FLIROneSDKBatteryChargingStateInvalid:
                chargingState = @"Invalid";
                break;
            default:
                chargingState = @"N/A";
                break;
        }
        [self.batteryChargingLabel setText:[NSString stringWithFormat:@"Charging: %@", chargingState]];
        
        
        if(self.currentlyRecording) {
            [self.captureVideoButton setTitle:@"Stop Video" forState:UIControlStateNormal];
        } else {
            [self.captureVideoButton setTitle:@"Start Video" forState:UIControlStateNormal];
        }
        
        [self.msxButton setTitle:[NSString stringWithFormat:@"MSX Distance: %@", (self.msxDistanceEnabled ? @"On" : @"Off")] forState:UIControlStateNormal];
        [self.emissivityButton setTitle:[NSString stringWithFormat:@"Emissivity: %0.2f", self.emissivity] forState:UIControlStateNormal];
        
        self.frameCountLabel.text = [NSString stringWithFormat:@"Count: %ld, %f", (long)self.frameCount, self.fps];
        
        [self.editButton setEnabled:(self.lastCapturePath != nil)];
    });
}

- (void) performTemperatureCalculationsFloat:(BOOL)isFloat {
    float temp;
    float hottestTemp;
    float coldestTemp;
    int index = 0;
    int coldIndex = 0;
    
    float minRegion = 0;
    int minRegionIndex = 0;
    float maxRegion = 0;
    int maxRegionIndex = 0;
    unsigned long regionCount = 0;
    double regionSum = 0;
    
    float *tempDataFloat = nullptr;
    uint16_t *tempDataInt = nullptr;
    
    if(isFloat) {
        tempDataFloat = (float *)[self.thermalData bytes];
        temp = tempDataFloat[0];
    }
    else {
        tempDataInt = (uint16_t *)[self.thermalData bytes];
        temp = tempDataInt[0]/100.0;
    }
    
    hottestTemp = temp;
    coldestTemp = temp;
    
    
    for(int i=0;i<self.thermalSize.width*self.thermalSize.height;i++) {
        if(isFloat) {
            temp = tempDataFloat[i];
        }
        else {
            temp = tempDataInt[i]/100.0;
        }
        if(temp > hottestTemp) {
            hottestTemp = temp;
            index = i;
        }
        if(temp < coldestTemp) {
            coldestTemp = temp;
            coldIndex = i;
        }
        CGFloat x = (i % (int)self.thermalSize.width)/self.thermalSize.width;
        CGFloat y = (i / self.thermalSize.width)/self.thermalSize.height;
        
        if(x > self.regionOfInterest.origin.x
           && x < self.regionOfInterest.origin.x + self.regionOfInterest.size.width
           && y > self.regionOfInterest.origin.y
           && y < self.regionOfInterest.origin.y + self.regionOfInterest.size.height) {
            
            if(regionCount == 0) {
                minRegion = temp;
                minRegionIndex = i;
                maxRegion = temp;
                maxRegionIndex = i;
            }
            else {
                if(temp > maxRegion) {
                    maxRegion = temp;
                    maxRegionIndex = i;
                }
                if(temp < minRegion) {
                    minRegion = temp;
                    minRegionIndex = i;
                }
            }
            
            regionCount += 1;
            regionSum += temp;
        }
    }
    double regionAverage = (regionSum/regionCount);
    
    NSInteger column = index % (int)self.thermalSize.width;
    NSInteger row = index / self.thermalSize.width;
    //update the thinger
    self.pixelOfInterest = CGPointMake(column/self.thermalSize.width, row/self.thermalSize.height);
    
    column = coldIndex % (int)self.thermalSize.width;
    row = coldIndex / self.thermalSize.width;
    self.coldPixel = CGPointMake(column/self.thermalSize.width, row/self.thermalSize.height);
    
    self.coldestTemperature = coldestTemp;
    self.pixelTemperature = hottestTemp;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.regionMaxLabel.text = [NSString stringWithFormat:@"%0.2fºC", maxRegion-273.15];
        self.regionMinLabel.text = [NSString stringWithFormat:@"%0.2fºC", minRegion-273.15];
        self.regionAverageLabel.text = [NSString stringWithFormat:@"%0.2fºC", regionAverage-273.15];
    });
    
    
}

//events relating to user tapping the image views, switches formats on and off

//cycle between thermal, MSX, and none
- (IBAction)thermalButtonPressed:(id)sender {
    if(self.options & FLIROneSDKImageOptionsThermalRGBA8888Image) {
        self.options = (FLIROneSDKImageOptions)(self.options & ~FLIROneSDKImageOptionsThermalRGBA8888Image);
        self.options = (FLIROneSDKImageOptions)(self.options | FLIROneSDKImageOptionsBlendedMSXRGBA8888Image);
    } else if(self.options & FLIROneSDKImageOptionsBlendedMSXRGBA8888Image) {
        self.options = (FLIROneSDKImageOptions)(self.options & ~FLIROneSDKImageOptionsBlendedMSXRGBA8888Image);
        self.thermalImage = nil;
    } else {
        self.options = (FLIROneSDKImageOptions)(self.options | FLIROneSDKImageOptionsThermalRGBA8888Image);
    }
    [FLIROneSDKStreamManager sharedInstance].imageOptions = self.options;
    
    [self updateUI];
}
//cycle between 14 bit linear, radiometric, and none
- (IBAction)thermal14BitButtonPressed:(id)sender {
    if(self.options & FLIROneSDKImageOptionsThermalLinearFlux14BitImage) {
        self.options = (FLIROneSDKImageOptions)(self.options & ~FLIROneSDKImageOptionsThermalLinearFlux14BitImage);
        self.options = (FLIROneSDKImageOptions)(self.options | FLIROneSDKImageOptionsThermalRadiometricKelvinImage);
    } else if(self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImage) {
        self.options = (FLIROneSDKImageOptions)(self.options & ~FLIROneSDKImageOptionsThermalRadiometricKelvinImage);
        self.options = (FLIROneSDKImageOptions)(self.options | FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat);
    } else if(self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat) {
        self.options = (FLIROneSDKImageOptions)(self.options & ~FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat);
        self.radiometricImage = nil;
    } else {
        self.options = (FLIROneSDKImageOptions)(self.options | FLIROneSDKImageOptionsThermalLinearFlux14BitImage);
    }
    
    [FLIROneSDKStreamManager sharedInstance].imageOptions = self.options;
    [self updateUI];
}
//enable/disable visual jpeg
- (IBAction)visualJPEGButtonPressed:(id)sender {
    self.options = (FLIROneSDKImageOptions)(self.options ^ FLIROneSDKImageOptionsVisualJPEGImage);
    if(!(self.options & FLIROneSDKImageOptionsVisualJPEGImage)) {
        self.visualJPEGImage = nil;
    }
    [FLIROneSDKStreamManager sharedInstance].imageOptions = self.options;
    [self updateUI];
}
//enable/disable visual ycbcr
- (IBAction)visualYCbCrButtonPressed:(id)sender {
    self.options = (FLIROneSDKImageOptions)(self.options ^ FLIROneSDKImageOptionsVisualYCbCr888Image);
    if(!(self.options & FLIROneSDKImageOptionsVisualYCbCr888Image)) {
        self.visualYCbCrImage = nil;
    }
    [FLIROneSDKStreamManager sharedInstance].imageOptions = self.options;
    [self updateUI];
}

- (void) FLIROneSDKDidConnect {
    self.connected = YES;
    self.isDongle = [[FLIROneSDKStreamManager sharedInstance] isDongle];
    self.isGen3Dongle = [[FLIROneSDKStreamManager sharedInstance] isGen3Dongle];
    self.isProDongle = [[FLIROneSDKStreamManager sharedInstance] isProDongle];
    self.frameCount = 0;
    
    [self updateUI];
}

- (void) FLIROneSDKDidDisconnect {
    self.connected = NO;
    [self updateUI];
}


//callbacks for image data delivered from sled
- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveFrameWithOptions:(FLIROneSDKImageOptions)options metadata:(FLIROneSDKImageMetadata *)metadata sequenceNumber:(NSInteger)sequenceNumber {
    
    self.emissivity = metadata.emissivity;
    self.palette = metadata.palette;
    
    self.frameCount += 1;
    
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if(self.lastTime > 0) {
        self.fps = 1.0/(now - self.lastTime);
    }
    
    self.lastTime = now;
    
    [self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveBlendedMSXRGBA8888Image:(NSData *)msxImage imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber {

    if(self.options & FLIROneSDKImageOptionsBlendedMSXRGBA8888Image) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsBlendedMSXRGBA8888Image andData:msxImage andSize:size];
            if(self.options & FLIROneSDKImageOptionsBlendedMSXRGBA8888Image) {
                self.thermalImage = image;
                [self updateUI];
            }
        });
    }
    else {
        self.thermalImage = nil;
        [self updateUI];
    }
    
    //[self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermalRGBA8888Image:(NSData *)thermalImage imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber {
    
    if(self.options & FLIROneSDKImageOptionsThermalRGBA8888Image) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRGBA8888Image andData:thermalImage andSize:size];
            if(self.options & FLIROneSDKImageOptionsThermalRGBA8888Image) {
                self.thermalImage = image;
                [self updateUI];
            }
        });
    }
    else {
        self.thermalImage = nil;
        [self updateUI];
    }
    
    //[self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveVisualYCbCr888Image:(NSData *)visualYCbCr888Image imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber {
    
    if(self.options & FLIROneSDKImageOptionsVisualYCbCr888Image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsVisualYCbCr888Image andData:visualYCbCr888Image andSize:size];
            
            if(self.options & FLIROneSDKImageOptionsVisualYCbCr888Image) {
                self.visualYCbCrImage = image;
                [self updateUI];
            }
        });
    }
    else {
        self.visualYCbCrImage = nil;
        [self updateUI];
    }
    
    //[self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveVisualJPEGImage:(NSData *)visualJPEGImage sequenceNumber:(NSInteger)sequenceNumber {
    
    
    if(self.options & FLIROneSDKImageOptionsVisualJPEGImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *rotatedJPEG = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsVisualJPEGImage andData:visualJPEGImage andSize:CGSizeZero];
            
            UIImage *image = [[UIImage alloc]
                                    initWithCGImage:rotatedJPEG.CGImage
                                    scale:1.0
                                    orientation:UIImageOrientationRight];
            if(self.options & FLIROneSDKImageOptionsVisualJPEGImage) {
                self.visualJPEGImage = image;
                [self updateUI];
            }
        });
    }
    else {
        self.visualJPEGImage = nil;
        [self updateUI];
    }
    
    //[self updateUI];
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermal14BitLinearFluxImage:(NSData *)linearFluxImage imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber {
    
    
    if(self.options & FLIROneSDKImageOptionsThermalLinearFlux14BitImage) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalLinearFlux14BitImage andData:linearFluxImage andSize:size];
            if(self.options & FLIROneSDKImageOptionsThermalLinearFlux14BitImage) {
                self.radiometricImage = image;
                [self updateUI];
            }
        });
    }
    else {
        self.radiometricImage = nil;
        [self updateUI];
    }
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricData:(NSData *)radiometricData imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber {
    
    
    if(self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImage) {
        @synchronized(self) {
            self.thermalDataIsFloats = NO;
            self.thermalData = radiometricData;
            self.thermalSize = size;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImage andData:radiometricData andSize:size];
            if(self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImage) {
                self.radiometricImage = image;
                [self updateUI];
            }
        });
    }
    else {
        self.radiometricImage = nil;
        [self updateUI];
    }
    
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricDataFloat:(NSData *)radiometricData imageSize:(CGSize)size sequenceNumber:(NSInteger)sequenceNumber {
    
    if(self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat) {
        @synchronized(self) {
            self.thermalDataIsFloats = YES;
            self.thermalData = radiometricData;
            self.thermalSize = size;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat andData:radiometricData andSize:size];
            if(self.options & FLIROneSDKImageOptionsThermalRadiometricKelvinImageFloat) {
                self.radiometricImage = image;
                [self updateUI];
            }
        });
    }
    else {
        self.radiometricImage = nil;
        [self updateUI];
    }
}

- (void)FLIROneSDKDidRenderToGLKView:(GLKView *)glkView sequenceNumber:(NSInteger)sequenceNumber {
    
}

- (void) FLIROneSDKAutomaticTuningDidChange:(NSNumber *)deviceWillTuneAutomatically{
    [self.autoTuneSwitch setOn:[deviceWillTuneAutomatically boolValue] animated:YES];
}

//callbacks relating to capturing images to library
- (void) FLIROneSDKDidFinishCapturingPhoto:(FLIROneSDKCaptureStatus)captureStatus withFilepath:(NSURL *)filepath {
    self.cameraBusy = NO;
    if(captureStatus == FLIROneSDKCaptureStatusSucceeded) {
        self.lastCapturePath = filepath;

        
    }
    [self updateUI];
}

//tuning callback
- (void) FLIROneSDKTuningStateDidChange:(FLIROneSDKTuningState)newTuningState {
    self.tuningState = newTuningState;
    [self updateUI];
}

//charging callback
- (void) FLIROneSDKBatteryChargingStateDidChange:(FLIROneSDKBatteryChargingState)state {
    self.batteryChargingState = state;
    [self updateUI];
}

//battery callback
- (void) FLIROneSDKBatteryPercentageDidChange:(NSNumber *)percentage {
    self.batteryPercentage = [percentage integerValue];
    [self updateUI];
}

//enable or disable MSX
- (IBAction) msxButtonPressed:(UIButton *)button {
    self.msxDistanceEnabled = !self.msxDistanceEnabled;
    
    [FLIROneSDKStreamManager sharedInstance].msxDistanceEnabled = YES;
    [FLIROneSDKStreamManager sharedInstance].msxDistance = self.msxDistanceEnabled ? 0 : 1;
    
}

- (IBAction) tuneThermalPressed:(UIButton *)button {
    [[FLIROneSDKStreamManager sharedInstance] performTuning];
}

- (IBAction) autoTuneToggle:(UISwitch *)tuneSwitch{
    [[FLIROneSDKStreamManager sharedInstance] setAutomaticTuning:[tuneSwitch isOn]];
}

//switch emissivity value to one of 5 values
- (IBAction) emissivityPressed:(UIButton *)button {
    CGFloat customValue = 0.5;
    
    if(fabs(self.emissivity - FLIROneSDKEmissivityGlossy) < 0.01) {
        self.emissivity = FLIROneSDKEmissivitySemiGlossy;
    } else if(fabs(self.emissivity - FLIROneSDKEmissivitySemiGlossy) < 0.01) {
        self.emissivity = FLIROneSDKEmissivitySemiMatte;
    } else if(fabs(self.emissivity - FLIROneSDKEmissivitySemiMatte) < 0.01) {
        self.emissivity = FLIROneSDKEmissivityMatte;
    } else if(fabs(self.emissivity - FLIROneSDKEmissivityMatte) < 0.01) {
        self.emissivity = customValue;
    } else if(fabs(self.emissivity - customValue) < 0.01) {
        self.emissivity = FLIROneSDKEmissivityGlossy;
    } else {
        self.emissivity = customValue;
    }
    [[FLIROneSDKStreamManager sharedInstance] setEmissivity:self.emissivity];
}
- (IBAction)vividIRQualityButtonPressed:(id)sender {
    
    switch([[FLIROneSDKStreamManager sharedInstance] vividIRQuality]) {
        case FLIROneSDKVividIRQualityNone:
            [FLIROneSDKStreamManager sharedInstance].vividIRQuality = FLIROneSDKVividIRQualityLow;
            [self.vividIRButton setTitle:@"Vivid IR: Low" forState:UIControlStateNormal];
            break;
        case FLIROneSDKVividIRQualityLow:
            [FLIROneSDKStreamManager sharedInstance].vividIRQuality = FLIROneSDKVividIRQualityHigh;
            [self.vividIRButton setTitle:@"Vivid IR: High" forState:UIControlStateNormal];
            break;
        case FLIROneSDKVividIRQualityHigh:
            [FLIROneSDKStreamManager sharedInstance].vividIRQuality = FLIROneSDKVividIRQualityNone;
            [self.vividIRButton setTitle:@"Vivid IR: None" forState:UIControlStateNormal];
            break;
    }
}

- (IBAction)capturePhoto:(id)sender {
    
    self.cameraBusy = YES;
    [self updateUI];
    
    NSURL *filepath = [FLIROneSDKLibraryManager libraryFilepathForCurrentTimestampWithExtension:@"jpg"];
    
    [[FLIROneSDKStreamManager sharedInstance] capturePhotoWithFilepath:filepath];
    switch(photoID){
        case 0:
            img0=self.captureView;
            photoURL0=filepath;
            break;
        case 1:
            img1=self.captureView;
            photoURL1=filepath;
            break;
        case 2:
            img2=self.captureView;
            photoURL2=filepath;
            break;
    }
    _flasher.highlighted=YES;
    _bottomBar.alpha=1;
    _startButton.alpha=0.5;
    if(photoID<2){
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(unFlash)
                                   userInfo:nil
                                    repeats:NO];
    }  else {
        _startButton.enabled=FALSE;
        _flasher.highlighted=TRUE;
        _edit1Button.alpha=1;
        _edit1Button.enabled=TRUE;
        _restartButton.enabled=TRUE;
        _restartButton.alpha=1;
        _successMessage.alpha=1;
        
    }

    
    
    
}



-(void) unFlash {
    _flasher.highlighted=NO;
    _imageBack.alpha=1;
    _imageFront.alpha=1;
    _imageSide.alpha=1;
    _settings.alpha=1;
    _expo.alpha=1;
    
}

- (IBAction) captureVideo:(id)sender {
    @synchronized([FLIROneSDKExampleViewController class]) {
        self.cameraBusy = YES;
        if(self.currentlyRecording) {
            //stop recording
            [[FLIROneSDKStreamManager sharedInstance] stopRecordingVideo];
        } else {
            NSURL *filepath = [FLIROneSDKLibraryManager libraryFilepathForCurrentTimestampWithExtension:@"mov"];
            [[FLIROneSDKStreamManager sharedInstance] startRecordingVideoWithFilepath:filepath withVideoRendererDelegate:self];
        }
        
        [self updateUI];
    }
}

- (IBAction)connectSimulator:(UIButton *)sender {
    [[FLIROneSDKSimulation sharedInstance] connectWithFrameBundleName:@"sampleframes_hq" withBatteryChargePercentage:@42];
    
}

- (IBAction)disconnectSimulator:(UIButton *)sender {
    [[FLIROneSDKSimulation sharedInstance] disconnect];
}
- (IBAction)spanLockButtonPressed:(id)sender {
    [FLIROneSDKStreamManager sharedInstance].spanLockEnabled = ![FLIROneSDKStreamManager sharedInstance].spanLockEnabled;
}

//callbacks for video recording
- (void) FLIROneSDKDidStartRecordingVideo:(FLIROneSDKCaptureStatus)captureStartStatus {
    if(captureStartStatus == FLIROneSDKCaptureStatusSucceeded) {
        self.currentlyRecording = YES;
        self.cameraBusy = YES;
    } else {
        self.cameraBusy = NO;
        self.currentlyRecording = NO;
    }
    
    [self updateUI];
}

- (void) FLIROneSDKDidStopRecordingVideo:(FLIROneSDKCaptureStatus)captureStopStatus {
    self.currentlyRecording = NO;
    
    if(captureStopStatus == FLIROneSDKCaptureStatusFailedWithUnknownError) {
        self.cameraBusy = NO;
    } else {
        self.cameraBusy = YES;
    }
    
    [self updateUI];
}

- (void) FLIROneSDKDidFinishWritingVideo:(FLIROneSDKCaptureStatus)captureWriteStatus withFilepath:(NSString *)videoFilepath {
    
    self.cameraBusy = NO;
    self.currentlyRecording = NO;
    
    [self updateUI];
}

//grab any valid image delivered from the sled
- (UIImage *)currentImage {
    
    if(self.thermalImage) {
        return self.thermalImage;
    }
    if(self.visualYCbCrImage) {
        return self.visualYCbCrImage;
    }
    if(self.radiometricImage) {
        return self.radiometricImage;
    }
    if(self.visualJPEGImage) {
        return self.visualJPEGImage;
    }
    return nil;
}


//callback for rendering video in arbitrary video format
- (UIImage *)imageForFrameAtTimestamp:(CMTime)timestamp {
    
    //NSTimeInterval uptime = [[NSProcessInfo processInfo] systemUptime];

    return [self currentImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editPhotoSegue"]) {
        FLIROneSDKEditorViewController *editorVC = (FLIROneSDKEditorViewController *)segue.destinationViewController;
        
        editorVC.filepath = photoURL0;
        editorVC.filepath1 = photoURL1;
        editorVC.filepath2 = photoURL2;
        editorVC.im0 = img0;
        editorVC.im1 = img1;
        editorVC.im2 = img2;

    } 
}
-(void) theAction {
    
    switch(photoID){
        case 0:
            _frontImage.highlighted=TRUE;
            _backImage.highlighted=FALSE;
            _sideImage.highlighted=FALSE;
            break;
        case 1:
            _frontImage.highlighted=FALSE;
            _backImage.highlighted=TRUE;
            _sideImage.highlighted=FALSE;
            break;
        case 2:
            _frontImage.highlighted=FALSE;
            _backImage.highlighted=FALSE;
            _sideImage.highlighted=TRUE;
            break;
    }
    timeTick=timeTick-1;
    _timerLab.text=[NSString stringWithFormat:@"%i", timeTick];
    if(timeTick>0){
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(theAction)
                                       userInfo:nil
                                        repeats:NO];
        
    } else {
        _timerLab.text=[NSString stringWithFormat:@"%s", ""];
        _imageBack.alpha=0;
        _imageFront.alpha=0;
        _imageSide.alpha=0;
        _settings.alpha=0;
        _expo.alpha=0;
        _bottomBar.alpha=0;
        _startButton.alpha=0;
        [self capturePhoto:nil];
        if(photoID<2){
            photoID=photoID+1;
            timeTick=timerLength+1;
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(theAction)
                                           userInfo:nil
                                            repeats:NO];
            
        } else {
            _timerLab.text=[NSString stringWithFormat:@"%s", ""];
            _frontImage.highlighted=FALSE;
            _backImage.highlighted=FALSE;
            _sideImage.highlighted=FALSE;
            
        }
        
    }
    
}
- (IBAction)start:(id)sender {
    _startButton.alpha=0.5;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(theAction)
                                   userInfo:nil
                                    repeats:NO];
}
@end
