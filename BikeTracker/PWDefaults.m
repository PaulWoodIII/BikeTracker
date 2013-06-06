//
//  PWDefaults.m
//  BikeTracker
//
//  Created by Paul Wood on 6/6/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWDefaults.h"

@implementation PWDefaults

NSString *const kPWPreferedRefreshTimeInterval = @"kPWPreferedRefreshTimeInterval";
NSString *const kPWPreferedRefreshWaitInterval = @"kPWPreferedRefreshWaitInterval";
NSString *const kPWPreferedRefreshDistance = @"kPWPreferedRefreshDistance";

+ (PWDefaults *)sharedInstance {
    static PWDefaults *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[PWDefaults alloc] init];
    });
    return __sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        [self loadFromUserPreferences];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(saveToUserPreferences)
         name:UIApplicationDidEnterBackgroundNotification
         object:nil];
        
    }
    return self;
}

- (void)loadFromUserPreferences{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *savedPreferedRefreshTimeInterval = [defaults objectForKey:kPWPreferedRefreshTimeInterval];
    if ([savedPreferedRefreshTimeInterval isEqualToNumber:@0.0]) {
        savedPreferedRefreshTimeInterval = @1.0;
    }
    if (savedPreferedRefreshTimeInterval) {
        self.preferedRefreshTimeInterval = [savedPreferedRefreshTimeInterval doubleValue];
    }
    
    NSNumber *savedPreferedRefreshWaitInterval = [defaults objectForKey:kPWPreferedRefreshWaitInterval];
    if ([savedPreferedRefreshWaitInterval isEqualToNumber:@0.0]) {
        savedPreferedRefreshWaitInterval = @1.0;
    }
    if (savedPreferedRefreshWaitInterval) {
        self.preferedRefreshWaitInterval = [savedPreferedRefreshWaitInterval doubleValue];
    }
    
    NSNumber *savedPreferedRefreshDistance = [defaults objectForKey:kPWPreferedRefreshDistance];
    if ([savedPreferedRefreshDistance isEqualToNumber:@0.0]) {
        savedPreferedRefreshDistance = @1.0;
    }
    if (savedPreferedRefreshDistance) {
        self.preferedRefreshDistance = [savedPreferedRefreshDistance doubleValue];
    }
}

- (void)saveToUserPreferences{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithDouble:self.preferedRefreshTimeInterval] forKey:kPWPreferedRefreshTimeInterval];
    [defaults setObject:[NSNumber numberWithDouble:self.preferedRefreshDistance] forKey:kPWPreferedRefreshDistance];
    [defaults setObject:[NSNumber numberWithDouble:self.preferedRefreshTimeInterval] forKey:kPWPreferedRefreshWaitInterval];
    [defaults synchronize];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
