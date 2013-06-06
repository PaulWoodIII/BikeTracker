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
@property (nonatomic, readwrite) NSTimeInterval refreshTimeInterval;
- (void)setRefreshTimeInterval:(NSTimeInterval)refreshTimeInterval;
@property (nonatomic, readwrite) NSTimeInterval refreshWaitInterval;
- (void)setRefreshWaitInterval:(NSTimeInterval)refreshWaitInterval;
@property (nonatomic, readwrite) CLLocationDistance refreshDistance;
- (void)setRefreshDistance:(CLLocationDistance)refreshDistance;

+ (PWLocationManager *) sharedInstance;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
