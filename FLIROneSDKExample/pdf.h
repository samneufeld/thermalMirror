//
//  pdf.h
//  FLIROneSDKExample
//
//  Created by Sam Neufeld on 11/9/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface pdf : UIViewController 

@property (strong, nonatomic) UIImage *im0;
@property (strong, nonatomic) UIImage *im1;
@property (strong, nonatomic) UIImage *im2;
@property (strong, nonatomic) IBOutlet UIImageView *image0;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIView *viewIm;
- (IBAction)button:(id)sender;



@end
