//
//  PWNetworkManager.m
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWNetworkManager.h"

@implementation PWNetworkManager

#define kServerURL @"http://172.16.1.20:3000"

+ (id)sharedInstance {
    static PWNetworkManager *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[PWNetworkManager alloc] initWithBaseURL:
                            [NSURL URLWithString:kServerURL]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

- (void)uploadStatusWithLocation:(CLLocation *)location
                    withSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:[NSNumber numberWithDouble:[location coordinate].latitude] forKey:@"lat"];
    [parameters setValue:[NSNumber numberWithDouble:[location coordinate].longitude] forKey:@"lng"];
    [parameters setValue:[NSNumber numberWithDouble:[location horizontalAccuracy]] forKey:@"hacc"];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"addLocation" parameters:parameters];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation
    setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success) {
            NSLog(@"network succes %@, with response: %@",operation, responseObject);
            success(responseObject);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (failure) {
            NSLog(@"network failure %@ with Error: %@", operation, error);
            failure(operation, error);
        }
    }];
    NSLog(@"network start");
    [self enqueueHTTPRequestOperation:operation];
}


@end
