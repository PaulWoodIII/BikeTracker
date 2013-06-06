//
//  PWFirstViewController.m
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWRecordViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PWLocationManager.h"
#import "PWNetworkManager.h"
#import "PWLocationsViewController.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIFont+FlatUI.h"

@interface PWRecordViewController ()

- (void)locationChanged;
- (void)locationFailed;
@property (nonatomic, retain) CLLocation *currentLocation;
@property BOOL isUpdating;
@end

@implementation PWRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isUpdating = NO;
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont: [UIFont boldFlatFontOfSize:18]};
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];

    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor]
                                  highlightedColor:[UIColor belizeHoleColor]
                                      cornerRadius:3
                                   whenContainedIn:[UINavigationBar class]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Locations"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(locations:)];
    [self.navigationItem.rightBarButtonItem removeTitleShadow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged) name:kPWLocationChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailed) name:kPWLocationNotFound object:nil];

    [self updateUI];
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
        [[PWLocationManager sharedInstance] startUpdatingLocation];
        self.isUpdating = YES;
    }
    [self updateUI];
}

- (void)locations:(id)sender {
    PWLocationsViewController* tableViewController = [[PWLocationsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void)makePauseButton{
    UIImage *pauseImage = [UIImage imageNamed:@"pause@2x.png"];
    UIImage *pauseSelectedImage = [UIImage imageNamed:@"pauseSelected@2x.png"];
    [self.startStopButton setBackgroundImage:pauseImage forState:UIControlStateNormal];
    [self.startStopButton setBackgroundImage:pauseSelectedImage forState:UIControlStateHighlighted];
}

- (void)makePlayButton{
    UIImage *playImage = [UIImage imageNamed:@"play@2x.png"];
    UIImage *playSelectedImage = [UIImage imageNamed:@"playSelected@2x.png"];
    [self.startStopButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [self.startStopButton setBackgroundImage:playSelectedImage forState:UIControlStateHighlighted];
}

- (void)updateUI{
    if (self.isUpdating) {
        [self makePauseButton];
    }
    else{
        [self makePlayButton];
    }
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
