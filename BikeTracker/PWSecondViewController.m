//
//  PWSecondViewController.m
//  BikeTracker
//
//  Created by Paul Wood on 3/10/13.
//  Copyright (c) 2013 paulwoodware. All rights reserved.
//

#import "PWSecondViewController.h"


@interface PWSecondViewController ()

@property (nonatomic,strong) SSWebView *webView;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UIBarButtonItem *backBarButton;
@property (nonatomic,strong) UIBarButtonItem *forwardBarButton;
@end

@implementation PWSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = self.view.frame.size;
    self.webView = [[SSWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
	self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleHeight;
	self.webView.scalesPageToFit = YES;
	self.webView.delegate = self;
	[self.view addSubview:self.webView];
    
    
    self.backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goBack)];
	self.forwardBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goForward)];
    
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
	self.navigationController.toolbar.tintColor = [UIColor colorWithRed:0.369f green:0.392f blue:0.447f alpha:1.0f];
    self.toolbarItems = [NSArray arrayWithObjects:
						 _backBarButton,
						 flexibleSpace,
						 _forwardBarButton,
						 flexibleSpace,
						 [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)],
						 nil];
    
    
	for (UIBarButtonItem *button in self.toolbarItems) {
		button.imageInsets = UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f);
	}
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];

    [self updateBrowserUI];
    [self loadURLString:@"http://192.168.1.188:3000"];
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
