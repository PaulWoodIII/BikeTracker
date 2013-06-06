//
//  PWSettingsViewController.m
//  BikeTracker
//
//  Created by Paul Wood on 6/6/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWSettingsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PWLocationManager.h"
#import "PWNetworkManager.h"
#import "UIColor+FlatUI.h"
#import "UISlider+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIFont+FlatUI.h"

@interface PWSettingsViewController ()

@end

@implementation PWSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18]};
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];

    
    [self.refreshWaitSlider configureFlatSliderWithTrackColor:[UIColor silverColor]
                                                progressColor:[UIColor alizarinColor]
                                                   thumbColor:[UIColor pomegranateColor]];
    
    [self.refreshTimeSlider configureFlatSliderWithTrackColor:[UIColor silverColor]
                                                progressColor:[UIColor alizarinColor]
                                                   thumbColor:[UIColor pomegranateColor]];
    
    [self.refreshDistanceSlider configureFlatSliderWithTrackColor:[UIColor silverColor]
                                                    progressColor:[UIColor alizarinColor]
                                                       thumbColor:[UIColor pomegranateColor]];
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sliderValueChanged:(id)sender{
    NSTimeInterval refreshTime = self.refreshWaitSlider.value;
    [(PWLocationManager *)[PWLocationManager sharedInstance] setRefreshWaitInterval:refreshTime];
    NSTimeInterval refreshDistance = self.refreshDistanceSlider.value;
    [(PWLocationManager *)[PWLocationManager sharedInstance] setRefreshDistance:refreshDistance];
    NSTimeInterval waitTime = self.refreshTimeSlider.value;
    [(PWLocationManager *)[PWLocationManager sharedInstance] setRefreshTimeInterval:waitTime];
    [self updateUI];
}

- (void)updateUI{
    self.refreshWaitSlider.value = [[PWLocationManager sharedInstance] refreshWaitInterval];
    self.refreshTimeSlider.value = [[PWLocationManager sharedInstance] refreshTimeInterval];
    self.refreshDistanceSlider.value = [[PWLocationManager sharedInstance] refreshDistance];
    self.refreshTimeLabel.text = [NSString stringWithFormat:@"%2.0f", [[PWLocationManager sharedInstance] refreshTimeInterval]];
    self.refreshWaitLabel.text = [NSString stringWithFormat:@"%2.0f", [[PWLocationManager sharedInstance] refreshWaitInterval]];
    self.refreshDistanceLabel.text = [NSString stringWithFormat:@"%2.0f", [[PWLocationManager sharedInstance] refreshDistance]];
}

@end
