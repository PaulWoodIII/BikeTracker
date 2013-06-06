//
//  PWSecondViewController.h
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSToolkit.h"

@interface PWMapViewController : UIViewController <SSWebViewDelegate>

@property (nonatomic, strong) UIToolbar *toolbar;

- (void)loadURLString:(NSString *)urlString;

@end
