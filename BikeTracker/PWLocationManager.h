//
//  PWLocationManager.h
//  BikeTracker
//
//  Created by Paul Wood on 3/13/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const kPWLocationChanged;
extern NSString *const kPWLocationNotFound;

@interface PWLocationManager : NSObject <CLLocationManagerDelegate> {
    
}

@property (nonatomic, retain) CLLocation *bestLocation;
@property (readwrite) NSTimeInterval waitTime;
- (void)setWaitTime:(NSTimeInterval)waitTime;
@property (readwrite) NSTimeInterval refreshRate;
- (void)setRefreshRate:(NSTimeInterval)refreshRate;
@property (readwrite) CLLocationDistance refreshDistance;
- (void)setRefreshDistance:(CLLocationDistance)refreshDistance;

+ (id) sharedInstance;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
