//
//  PWFirstViewController.h
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWFirstViewController : UIViewController {
    
}

- (IBAction)startStopPress:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@property (nonatomic, assign) IBOutlet UIButton *startStopButton;
@property (nonatomic, assign) IBOutlet UISlider *waitTime;
@property (nonatomic, assign) IBOutlet UISlider *refreshRate;
@property (nonatomic, assign) IBOutlet UISlider *refreshDistance;
@property (nonatomic, assign) IBOutlet UILabel *waitTimeLabel;
@property (nonatomic, assign) IBOutlet UILabel *refreshRateLabel;
@property (nonatomic, assign) IBOutlet UILabel *refreshDistanceLabel;

@end
