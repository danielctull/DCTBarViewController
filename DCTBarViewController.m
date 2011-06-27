/*
 DCTBarViewController.m
 DCTBarViewController
 
 Created by Daniel Tull on 23.10.2009.
 
 
 
 Copyright (c) 2009 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DCTBarViewController.h"

@interface DCTBarViewController ()
- (CGRect)dctInternal_barFrameForInterfaceOrientation:(UIInterfaceOrientation)orientation
											barHidden:(BOOL)theBarHidden;

- (CGRect)dctInternal_contentFrameForInterfaceOrientation:(UIInterfaceOrientation)orientation
												barHidden:(BOOL)theBarHidden;

- (CGSize)dctInternal_sizeForBarMetrics:(UIBarMetrics)barMetrics;
- (CGSize)dctInternal_sizeForOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (UIView *)dctInternal_contentView;
@end

@implementation DCTBarViewController {
	__strong NSMutableDictionary *barMetricsDictionary;
	__strong UIView *_contentView;
}

@synthesize position, barView, viewController, barHidden;

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIView *contentView = [self dctInternal_contentView];
	
	[self.view addSubview:contentView];
	
	self.barView.frame = [self dctInternal_barFrameForInterfaceOrientation:self.interfaceOrientation
																 barHidden:self.barHidden];
	
	if (self.position == DCTBarPositionTop)
		self.barView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
	
	else if (self.position == DCTBarPositionBottom)
		self.barView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
	
	else if (self.position == DCTBarPositionRight)
		self.barView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin);
	
	else if (self.position == DCTBarPositionLeft)
		self.barView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin);
	
	[self.view addSubview:self.barView];
	contentView.frame = [self dctInternal_contentFrameForInterfaceOrientation:self.interfaceOrientation barHidden:self.barHidden];
	UIViewAutoresizing resizing = (UIViewAutoresizingFlexibleHeight |
								   UIViewAutoresizingFlexibleWidth);
	
	contentView.autoresizingMask = resizing;
	self.view.autoresizingMask = resizing;
	self.viewController.view.autoresizingMask = resizing;
	self.viewController.view.frame = contentView.bounds;
	self.viewController.wantsFullScreenLayout = NO;
	
	[contentView addSubview:self.viewController.view];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.barView = nil;
	_contentView = nil;
}

- (UITabBarItem *)tabBarItem {
	return [self.viewController tabBarItem];
}

- (UINavigationItem *)navigationItem {
	return [self.viewController navigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	[self.viewController didReceiveMemoryWarning];
}

#pragma mark - UIViewController view event methods

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.viewController viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.viewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.viewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.viewController viewDidDisappear:animated];
}

#pragma mark - UIViewController autorotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	
	if (!(self.viewController)) return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
	
	return [self.viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	BOOL currentlyPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
	BOOL toPortrait = UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
	
	if (currentlyPortrait == toPortrait) return;
	
	self.barView.frame = [self dctInternal_barFrameForInterfaceOrientation:toInterfaceOrientation barHidden:self.barHidden];
	[self dctInternal_contentView].frame = [self dctInternal_contentFrameForInterfaceOrientation:toInterfaceOrientation barHidden:self.barHidden];
	
}

#pragma mark - DCTContentViewController

- (void)setSize:(CGSize)size forBarMetrics:(UIBarMetrics)barMetrics {
	
	NSValue *sizeValue = [NSValue valueWithCGSize:size];
	NSNumber *barMetricsNumber = [NSNumber numberWithInteger:barMetrics];
	
	[barMetricsDictionary setObject:sizeValue forKey:barMetricsNumber];
}

- (CGSize)dctInternal_sizeForBarMetrics:(UIBarMetrics)barMetrics {
	NSNumber *barMetricsNumber = [NSNumber numberWithInteger:barMetrics];
	
	if (![[barMetricsDictionary allKeys] containsObject:barMetricsNumber])
		barMetricsNumber = [NSNumber numberWithInteger:UIBarMetricsDefault];
	
	NSValue *sizeValue = [barMetricsDictionary objectForKey:barMetricsNumber];
	return [sizeValue CGSizeValue];
}

- (CGSize)dctInternal_sizeForOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
		return [self dctInternal_sizeForBarMetrics:UIBarMetricsLandscapePhone];
	
	return [self dctInternal_sizeForBarMetrics:UIBarMetricsDefault];
}

- (id)initWithViewController:(UIViewController *)aViewController {
	
	if (!(self = [self initWithNibName:nil bundle:nil])) return nil;
	
	self.viewController = aViewController;
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	
	self.wantsFullScreenLayout = NO;
	barMetricsDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
	
	[self setSize:CGSizeMake(320.0f, 44.0f) forBarMetrics:UIBarMetricsDefault];
	
	return self;
}

- (void)awakeFromNib {
	self.wantsFullScreenLayout = NO;
	barMetricsDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
	
	[self setSize:CGSizeMake(320.0f, 44.0f) forBarMetrics:UIBarMetricsDefault];
}

- (void)setViewController:(UIViewController *)aViewController {
	
	if (self.viewController == aViewController) return;
	
	[self.viewController removeFromParentViewController];
	viewController = aViewController;
	[self addChildViewController:self.viewController];
}

- (UIView *)dctInternal_contentView {
	
	if (_contentView == nil) {
		CGRect contentRect = [self dctInternal_contentFrameForInterfaceOrientation:self.interfaceOrientation barHidden:self.barHidden];
		_contentView = [[UIView alloc] initWithFrame:contentRect];
	}
	
	return _contentView;
}

- (UIView *)barView {
	
	if (!barView) [self loadBarView];
	
	if (!barView) {
		CGRect barRect = [self dctInternal_barFrameForInterfaceOrientation:self.interfaceOrientation barHidden:self.barHidden];
		barView = [[UIView alloc] initWithFrame:barRect];
	}
	
	return barView;
}

- (void)setBarHidden:(BOOL)aBool {
	[self setBarHidden:aBool animated:NO completion:nil];
}

- (void)setBarHidden:(BOOL)hidden animated:(BOOL)animated {
	[self setBarHidden:hidden animated:animated completion:nil];
}

- (void)setBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	
	if (barHidden == hidden) return;
	
	barHidden = hidden;
	
	if (self.position == DCTBarPositionNone) return;
		
	NSTimeInterval timeInterval = 0.0f;
	if (animated) timeInterval = 1.0f / 3.0f;
	
	if (hidden) 
		self.dctInternal_contentView.frame = [self dctInternal_contentFrameForInterfaceOrientation:self.interfaceOrientation barHidden:hidden];
	else
		completion = ^(BOOL finished) {
			self.dctInternal_contentView.frame = [self dctInternal_contentFrameForInterfaceOrientation:self.interfaceOrientation barHidden:hidden];
			if (completion != nil) completion(finished);
		};
	
	[UIView animateWithDuration:timeInterval animations:^{
		
		self.barView.frame = [self dctInternal_barFrameForInterfaceOrientation:self.interfaceOrientation barHidden:hidden];
		
	} completion:completion];
}

#pragma mark - Framing methods

- (CGRect)dctInternal_barFrameForInterfaceOrientation:(UIInterfaceOrientation)orientation
											barHidden:(BOOL)theBarHidden {
	
	if (self.position == DCTBarPositionNone) return CGRectZero;
	
	CGSize size = [self dctInternal_sizeForOrientation:orientation];
	
	CGFloat barWidth = size.width;
	CGFloat barHeight = size.height;
	
	CGRect viewFrame = self.view.frame;
	/*
	// For some reason when in landscape the view size comes 
	// back the same as the portrait, so I flip it here.
	// Must be a nicer way to check for this?
	CGRect viewFrame = self.view.frame;
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		CGFloat height = viewFrame.size.height;
		viewFrame.size.height = viewFrame.size.width;
		viewFrame.size.width = height;
	}*/
	
	CGRect rect = CGRectMake(0.0f, 0.0f, barWidth, barHeight);
	
	if (self.position == DCTBarPositionBottom)
		rect.origin.y = viewFrame.size.height - barHeight;
	
	else if (self.position == DCTBarPositionRight)
		rect.origin.x = viewFrame.size.width - barWidth;
	
	if (theBarHidden) {
		
		if (self.position == DCTBarPositionBottom)
			rect.origin.y = viewFrame.size.height;
			
		else if (self.position == DCTBarPositionTop)
			rect.origin.y = 0.0f - barHeight;
		
		else if (self.position == DCTBarPositionRight)
			rect.origin.x = viewFrame.size.width;
			
		else if (self.position == DCTBarPositionLeft)
			rect.origin.x = 0.0f - barWidth;
	}
	
	return rect;
}

- (CGRect)dctInternal_contentFrameForInterfaceOrientation:(UIInterfaceOrientation)orientation
												barHidden:(BOOL)theBarHidden {
	
	if (self.position == DCTBarPositionNone) return self.view.bounds;
	
	if (theBarHidden) return self.view.bounds;
	
	CGSize size = [self dctInternal_sizeForOrientation:orientation];
	
	CGFloat barWidth = size.width;
	CGFloat barHeight = size.height;
		
	CGRect rect = self.view.bounds;
	
	if (self.position == DCTBarPositionBottom) {
		rect.size.height = rect.size.height - barHeight;
	
	} else if (self.position == DCTBarPositionTop) {
		rect.origin.y = barHeight;
		rect.size.height = rect.size.height - barHeight;
	
	} else if (self.position == DCTBarPositionRight) {
		rect.size.width = rect.size.width - barWidth;
		
	} else if (self.position == DCTBarPositionLeft) {
		rect.origin.x = barWidth;
		rect.size.width = rect.size.width - barWidth;
	}
	
	return rect;
}

#pragma mark - Methods for subclasses to use

- (void)loadBarView {}

@end

@implementation UIViewController (DCTBarViewController)


- (id)dct_ancestorViewControllerOfClass:(Class)aClass {
	
	UIViewController *vc = self;
	
	while (vc != nil) {
		
		if ([vc isKindOfClass:aClass]) return vc;
		
		vc = vc.parentViewController;
	}
	
	return nil;
}

@end
