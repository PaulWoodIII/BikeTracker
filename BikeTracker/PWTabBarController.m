//
//  PWTabBarController.m
//  BikeTracker
//
//  Created by Paul Wood on 6/6/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWTabBarController.h"
#import "UIColor+FlatUI.h"
#import "UIImage+FlatUI.h"
#import "UITabBar+FlatUI.h"

@interface PWTabBarController ()

@end

@implementation PWTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar configureFlatTabBarWithColor:[UIColor midnightBlueColor]  selectedColor:[UIColor peterRiverColor]];
    
    //set the tab bar title appearance for normal state
    [[UITabBarItem appearance]
     setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor concreteColor],
     UITextAttributeFont:[UIFont boldSystemFontOfSize:12.0f]}
     forState:UIControlStateNormal];
    
    //set the tab bar title appearance for selected state
    [[UITabBarItem appearance]
     setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor cloudsColor],
     UITextAttributeFont:[UIFont boldSystemFontOfSize:12.0f]}
     forState:UIControlStateHighlighted];

}

@end
