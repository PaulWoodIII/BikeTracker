//
//  PWSecondViewController.m
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWMapViewController.h"
#import "UIColor+FlatUI.h"
#import "UIImage+FlatUI.h"

@interface PWMapViewController ()

@property (nonatomic,strong) SSWebView *webView;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UIBarButtonItem *backBarButton;
@property (nonatomic,strong) UIBarButtonItem *forwardBarButton;
@end

@implementation PWMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor cloudsColor];
    CGSize size = self.view.frame.size;
    self.webView = [[SSWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
	self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
	self.webView.scalesPageToFit = YES;
	self.webView.delegate = self;
	[self.view addSubview:self.webView];
    
    
    self.backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goBack)];
	self.forwardBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goForward)];
    
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbar.tintColor = [UIColor midnightBlueColor];
    [self.toolbar setBackgroundImage:[UIImage imageWithColor:[UIColor midnightBlueColor] cornerRadius:0.0]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[[UIImage alloc] init]
              forToolbarPosition:UIToolbarPositionAny];
    
    self.toolbar.items = [NSArray arrayWithObjects:
						 _backBarButton,
						 flexibleSpace,
						 _forwardBarButton,
						 flexibleSpace,
						 [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)],
						 nil];
    
    
	for (UIBarButtonItem *button in self.toolbarItems) {
		button.imageInsets = UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f);
	}
    [self.navigationController setNavigationBarHidden:YES];

    [self updateBrowserUI];
    [self loadURLString:@"172.16.1.20:3000"];
}

- (void)updateBrowserUI{
	_backBarButton.enabled = [_webView canGoBack];
	_forwardBarButton.enabled = [_webView canGoForward];
    
	UIBarButtonItem *reloadButton = nil;
    
	if ([_webView isLoadingPage]) {
		[_indicator startAnimating];
		reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(stopLoading)];
	} else {
		[_indicator stopAnimating];
		reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)];
	}
	reloadButton.imageInsets = UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f);
    
	NSMutableArray *items = [self.toolbarItems mutableCopy];
	[items replaceObjectAtIndex:4 withObject:reloadButton];
	self.toolbarItems = items;
}

#pragma mark - SSWebViewDelegate

- (void)webViewDidStartLoadingPage:(SSWebView *)aWebView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateBrowserUI];
}

- (void)webViewDidLoadDOM:(SSWebView *)aWebView {
    
}

- (void)webViewDidFinishLoadingPage:(SSWebView *)aWebView {
	[self updateBrowserUI];
}

- (void)webView:(SSWebView *)aWebView didFailLoadWithError:(NSError *)error {
    [self updateBrowserUI];
}

- (void)loadURLString:(NSString *)urlString{
    [_webView loadURLString:urlString];
}

@end
