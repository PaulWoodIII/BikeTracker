//
//  PWFirstViewController.m
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWFirstViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PWLocationManager.h"
#import "PWNetworkManager.h"

@interface PWFirstViewController ()

- (void)locationChanged;
- (void)locationFailed;
@property (nonatomic, retain) CLLocation *currentLocation;
@property BOOL isUpdating;
@end

@implementation PWFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isUpdating = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged) name:kPWLocationChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailed) name:kPWLocationNotFound object:nil];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopPress:(id)sender{    
    if (self.isUpdating) {
        [[PWLocationManager sharedInstance] stopUpdatingLocation];
        self.isUpdating = NO;
    }
    else{
        [self sliderValueChanged:nil];
        [[PWLocationManager sharedInstance] startUpdatingLocation];
        self.isUpdating = YES;
    }
    [self updateUI];
}

- (IBAction)sliderValueChanged:(id)sender{
    NSTimeInterval refreshTime = self.refreshRate.value;
    [(PWLocationManager *)[PWLocationManager sharedInstance] setRefreshRate:refreshTime];
    NSTimeInterval refreshDistance = self.refreshDistance.value;
    [(PWLocationManager *)[PWLocationManager sharedInstance] setRefreshDistance:refreshDistance];
    NSTimeInterval waitTime = self.waitTime.value;
    [(PWLocationManager *)[PWLocationManager sharedInstance] setWaitTime:waitTime];
    [self updateUI];
}

- (void)updateUI{
    if (self.isUpdating) {
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else{
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    self.waitTimeLabel.text = [NSString stringWithFormat:@"%2.0f", self.waitTime.value];
    self.refreshRateLabel.text = [NSString stringWithFormat:@"%2.0f", self.refreshRate.value];
    self.refreshDistanceLabel.text = [NSString stringWithFormat:@"%2.0f", self.refreshDistance.value];
}

- (void)locationChanged{
    NSLog(@"Location: %@",[[PWLocationManager sharedInstance] bestLocation]);
    [[PWNetworkManager sharedInstance] uploadStatusWithLocation:[[PWLocationManager sharedInstance] bestLocation] withSuccess:^(id responseObject) {
        NSLog(@"Successful Location Post");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed Location Post");
    }];
}

- (void)locationFailed{
    
}

@end
