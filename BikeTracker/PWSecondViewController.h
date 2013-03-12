//
//  PWSecondViewController.h
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSToolkit.h"

@interface PWSecondViewController : UIViewController <SSWebViewDelegate>

- (void)loadURLString:(NSString *)urlString;

@end
