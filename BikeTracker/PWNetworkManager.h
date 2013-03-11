//
//  PWNetworkManager.h
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "AFNetworking.h"

@interface PWNetworkManager : AFHTTPClient

+ (id)sharedInstance;

@end
