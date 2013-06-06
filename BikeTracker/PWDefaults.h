//
//  PWDefaults.h
//  BikeTracker
//
//  Created by Paul Wood on 6/6/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PWDefaults : NSObject

@property (readwrite) NSTimeInterval preferedRefreshTimeInterval;
@property (readwrite) NSTimeInterval preferedRefreshWaitInterval;
@property (readwrite) CLLocationDistance preferedRefreshDistance;

+ (PWDefaults *)sharedInstance;

@end
