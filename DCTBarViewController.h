/*
 DCTBarViewController.h
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

#import <UIKit/UIKit.h>

typedef enum {
	DCTBarPositionNone = 0,
	DCTBarPositionLeft,
	DCTBarPositionRight,
	DCTBarPositionTop,
	DCTBarPositionBottom
} DCTBarPosition;

@interface DCTBarViewController : UIViewController

/// @name Creating a Content View Controller
/**
 
 */
- (id)initWithViewController:(UIViewController *)aViewController;

/** The position of the bar view.
 
 Possible values are:
 
 * `DCTBarPositionNone` Do not show the bar view - pretty pointless.
 * `DCTBarPositionLeft` Show the bar view on the left.
 * `DCTBarPositionRight` Show the bar view on the right.
 * `DCTBarPositionTop` Show the bar view above the content view.
 * `DCTBarPositionBottom` Show the bar view below the content view.
 
 */
@property (nonatomic, assign) DCTBarPosition position;

/*
 
 */
- (void)setSize:(CGSize)size forBarMetrics:(UIBarMetrics)barMetrics;

@property (nonatomic, strong) IBOutlet UIViewController *viewController;
@property (nonatomic, strong) IBOutlet UIView *barView;

/** The place for subclasses to load the content view.*/

- (void)loadBarView;

@property (nonatomic, assign) BOOL barHidden;
- (void)setBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setBarHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end

@interface UIViewController (DCTBarViewController)
- (id)dct_ancestorViewControllerOfClass:(Class)aClass;
@end

