//
//  PWSettingsViewController.h
//  BikeTracker
//
//  Created by Paul Wood on 6/6/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWSettingsViewController : UIViewController {
    
}

- (IBAction)sliderValueChanged:(id)sender;

@property (nonatomic, assign) IBOutlet UISlider *refreshTimeSlider;
@property (nonatomic, assign) IBOutlet UISlider *refreshWaitSlider;
@property (nonatomic, assign) IBOutlet UISlider *refreshDistanceSlider;
@property (nonatomic, assign) IBOutlet UILabel *refreshTimeLabel;
@property (nonatomic, assign) IBOutlet UILabel *refreshWaitLabel;
@property (nonatomic, assign) IBOutlet UILabel *refreshDistanceLabel;

@end
