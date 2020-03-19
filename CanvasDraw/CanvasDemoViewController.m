//
//  CanvasDemoViewController.m
//  CanvasDraw
//
//  Created by Don Mag on 3/18/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

#import "CanvasDemoViewController.h"
#import "Sizes.h"
#import "CanvasView.h"

@interface CanvasDemoViewController ()

@property (strong, nonatomic) CanvasView *inputView;
@property (strong, nonatomic) CanvasView *outputView;

@end

@implementation CanvasDemoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
}

- (void)setupViews {
	
	// create input and output views
	self.inputView = [CanvasView new];
	self.outputView = [CanvasView new];

	// using auto-layout
	self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
	self.outputView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// add views to self.view
	[self.view addSubview:self.inputView];
	[self.view addSubview:self.outputView];
	
	// respect safeArea
	UILayoutGuide *g = self.view.safeAreaLayoutGuide;
	
	[NSLayoutConstraint activateConstraints:@[
		
		// constrain inputView to safeArea Top + 8-pts
		[self.inputView.topAnchor constraintEqualToAnchor:g.topAnchor constant:8.0],
		
		// constrain inputView centerX
		[self.inputView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		
		// constrain inputView Width, Height
		[self.inputView.widthAnchor constraintEqualToConstant:inputWidth],
		[self.inputView.heightAnchor constraintEqualToConstant:inputHeight],
		
		// constrain outputView Top to inputView Bottom + 20-pts
		[self.outputView.topAnchor constraintEqualToAnchor:self.inputView.bottomAnchor constant:20.0],
		
		// constrain outputView centerX to topView centerX
		[self.outputView.centerXAnchor constraintEqualToAnchor:self.inputView.centerXAnchor],
		
		// constrain outputView Width, Height to same as inputView
		[self.outputView.widthAnchor constraintEqualToConstant:inputWidth],
		[self.outputView.heightAnchor constraintEqualToConstant:inputHeight],
		
	]];
	
	// calculate scaled size for outputView
	CGFloat wScale = outputWidth / inputWidth;
	CGFloat hScale = outputHeight / inputHeight;
	
	// CGAffineTransformScale scales from the center of the view (0.5,0.5)
	// so calculate anchor point to keep the top at its original position
	// if our views are not horizontally centered, we'd also need to calculate
	// the xAnchor adjustment
	CGFloat yAnchor = 0.5 / hScale;
	[self.outputView.layer setAnchorPoint:CGPointMake(0.5, yAnchor)];
	
	// scale the outputView
	CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, wScale, hScale);
	[self.outputView setTransform:t];
	
	// allow drawing on the inputView
	[self.inputView enableDrawing:YES];
	
	// don't allow drawing on the outputView
	// (also sets the outputView as the notification receiver)
	[self.outputView enableDrawing:NO];

	self.inputView.backgroundColor = [UIColor cyanColor];
	self.outputView.backgroundColor = [UIColor yellowColor];

}

@end
