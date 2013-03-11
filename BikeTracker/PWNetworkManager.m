//
//  PWNetworkManager.m
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWNetworkManager.h"

@implementation PWNetworkManager

#define kServerURL @"http://192.168.1.4:3000/"

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

- (void)uploadStatusWithComment:(NSString *)comment
                        withLat:(float)lat
                        withLng:(float)lng
                    withSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setValue:comment forKey:@"title"];
    [parameters setValue:[NSNumber numberWithFloat:lat] forKey:@"lat"];
    [parameters setValue:[NSNumber numberWithFloat:lng] forKey:@"long"];
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"locations" parameters:parameters];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success) {
            success(responseObject);
        }
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (failure) {
            failure(operation, error);
        }
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}


@end
