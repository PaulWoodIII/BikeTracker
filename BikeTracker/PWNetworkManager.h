//
//  PWNetworkManager.h
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@interface PWNetworkManager : AFHTTPClient

+ (id)sharedInstance;

- (void)uploadStatusWithLocation:(CLLocation *)location
                     withSuccess:(void (^)(id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
