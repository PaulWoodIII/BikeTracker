//
//  PWAppDelegate.h
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWAppDelegate : UIResponder <UIApplicationDelegate> {
    UIBackgroundTaskIdentifier bgTask;
}

@property (strong, nonatomic) UIWindow *window;

@end
