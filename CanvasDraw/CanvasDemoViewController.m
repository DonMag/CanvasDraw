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
	
	[self setupViews];
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
		[self.outputView.widthAnchor constraintEqualToConstant:outputWidth],
		[self.outputView.heightAnchor constraintEqualToConstant:outputHeight],
		
	]];
	
	// allow drawing on the inputView
	[self.inputView enableDrawing:YES];
	
	// don't allow drawing on the outputView
	// (also sets the outputView as the notification receiver)
	[self.outputView enableDrawing:NO];

	// background colors so we can see the frames
	self.inputView.backgroundColor = [UIColor cyanColor];
	self.outputView.backgroundColor = [UIColor yellowColor];

}

@end
