//
//  PWLocationManager.m
//  BikeTracker
//
//  Created by Paul Wood on 3/13/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWLocationManager.h"
#include <stdlib.h>
#import "PWDefaults.h"

@interface PWLocationManager ()

@property (nonatomic, retain) CLLocationManager *coreLocation;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocation *lastPostedLocation;

@end

@implementation PWLocationManager

NSString *const kPWLocationChanged = @"kPWLocationChanged";
NSString *const kPWLocationNotFound = @"kPWLocationNotFound";

#pragma mark -
#pragma mark Singelton methods

+ (PWLocationManager *)sharedInstance {
    static PWLocationManager *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[PWLocationManager alloc] init];
    });
    return __sharedInstance;
}


- (id)init{
    self = [super init];
    if (self) {
        self.coreLocation = [[CLLocationManager alloc] init];
        self.coreLocation.delegate = self;
        self.coreLocation.desiredAccuracy = kCLLocationAccuracyBest;
        self.refreshTimeInterval = [PWDefaults sharedInstance].preferedRefreshTimeInterval;
        self.refreshWaitInterval = [PWDefaults sharedInstance].preferedRefreshWaitInterval;
        self.refreshDistance = [PWDefaults sharedInstance].preferedRefreshDistance;
    }
    return self;
}

- (void)setRefreshTimeInterval:(NSTimeInterval)refreshTimeInterval{
    if (refreshTimeInterval < 1.0) {
        refreshTimeInterval = 1.0;
    }
    _refreshTimeInterval = refreshTimeInterval;
    [PWDefaults sharedInstance].preferedRefreshTimeInterval = refreshTimeInterval;
}

- (void)setRefreshWaitInterval:(NSTimeInterval)refreshWaitInterval{
    if (refreshWaitInterval < 1.0) {
        refreshWaitInterval = 1.0;
    }
    _refreshWaitInterval = refreshWaitInterval;
    [PWDefaults sharedInstance].preferedRefreshWaitInterval = refreshWaitInterval;
}

- (void)setRefreshDistance:(CLLocationDistance)refreshDistance{
    if (refreshDistance < 1.0) {
        refreshDistance = 1.0;
    }
    _refreshDistance = refreshDistance;
    [PWDefaults sharedInstance].preferedRefreshDistance = refreshDistance;
}


- (void)startUpdatingLocation{
    [self refreshLocation];
}

- (void)stopUpdatingLocation{
    [self stopUpdatingLocation:NSLocalizedString(@"User Requested Stop", @"User Requested Stop")];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateAfterTimer) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timedOutUseBest) object:nil];
}

- (void)startUpdateTimer{
    [self performSelector:@selector(updateAfterTimer) withObject:nil afterDelay:self.refreshWaitInterval];
}

- (void)updateAfterTimer{
    [self refreshLocation];
}

- (void)handleAccurateLocation:(CLLocation *)location{
    self.bestLocation = location;
    
    if ( nil == self.lastPostedLocation || [self.lastPostedLocation distanceFromLocation:self.bestLocation] > self.refreshDistance) {
        self.lastPostedLocation = self.bestLocation;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPWLocationChanged object:self.bestLocation];
    }
    [PWDefaults sharedInstance].preferedRefreshWaitInterval = self.refreshWaitInterval;
    [PWDefaults sharedInstance].preferedRefreshTimeInterval = self.refreshTimeInterval;
    [PWDefaults sharedInstance].preferedRefreshDistance = self.refreshDistance;
    [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
    self.bestLocation = location;
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = [locations lastObject];

    // store all of the measurements, just so we can see what kind of data we might receive
    NSLog(@"Location: %@",newLocation);

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateAfterTimer) object:nil];
    
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.currentLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters) {
            [self handleAccurateLocation:newLocation];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timedOutUseBest) object:nil];
            [self startUpdateTimer];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    
#if TARGET_IPHONE_SIMULATOR
    float low_bound = -0.009;
    float high_bound = 0.009;
    float rndValue1 = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    float rndValue2 = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    
    //Near Office
    CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(31.208621 + rndValue1, 121.469271 + rndValue2);
    CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:cord altitude:100.1 horizontalAccuracy:65.0 verticalAccuracy:10.0 course:80.0 speed:12.0 timestamp:[NSDate date]];
    CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:31.208621 longitude:121.469271];
    NSArray *locations = @[oldLocation,newLocation];
    [self locationManager:manager didUpdateLocations:locations];
#else
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPWLocationNotFound object:self.bestLocation];
#endif
    
}


- (void)timedOutUseBest{
    NSLog(@"Timed Out using best Location: %@, with desired Accuracy is: %f", self.bestLocation, self.coreLocation.desiredAccuracy);
    if (self.currentLocation != nil) {
        [self handleAccurateLocation:self.currentLocation];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kPWLocationNotFound object:nil];
    }
    [self stopUpdatingLocation:NSLocalizedString(@"Timed Out using best location", @"Timed Out using best location")];
    [self startUpdateTimer];
}

- (void)stopUpdatingLocation:(NSString *)state {
    NSLog(@"Stopped Updating Location: %@",state);
    [self.coreLocation stopUpdatingLocation];
    self.coreLocation.delegate = nil;
}

- (void)refreshLocation{
    
    NSTimeInterval locationAge = -[self.bestLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge < self.refreshWaitInterval && locationAge > 0) {
        return;
    }
    self.coreLocation.delegate = self;
    self.currentLocation = nil;
    [self.coreLocation startUpdatingLocation];

#if TARGET_IPHONE_SIMULATOR
    if (![CLLocationManager locationServicesEnabled]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPWLocationNotFound object:self.bestLocation];
    }
#endif

    BOOL authorizationStatus = YES;
    if ([CLLocationManager respondsToSelector:@selector(authorizationStatus)]){
        authorizationStatus = [CLLocationManager authorizationStatus];
    }
    if ([CLLocationManager locationServicesEnabled] && authorizationStatus){
        [self performSelector:@selector(timedOutUseBest) withObject:nil afterDelay:self.refreshTimeInterval];
    }
    
}
@end
