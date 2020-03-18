//
//  TransformScaleViewController.m
//  CanvasDraw
//
//  Created by Don Mag on 3/18/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

#import "TransformScaleViewController.h"
#import "Sizes.h"
#import "CanvasView.h"

@interface TransformScaleViewController ()

@property (strong, nonatomic) CanvasView *inputView;
@property (strong, nonatomic) CanvasView *outputView;

@property (strong, nonatomic) UIView *containerView;

@end

@implementation TransformScaleViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	// CGAffineTransformScale scales to the center of the view
	// by using a "container" view for the bottom view, it's much
	// easier to maintain the "target" frame
	[self setupWithContainer];
	
	// without a container view, we also have to change the
	// anchor point on the bottom view to keep the frame at its original position
	//[self setupWithoutContainer];
	
}

- (void)setupWithContainer {
	
	// create topView
	self.inputView = [CanvasView new];
	self.inputView.backgroundColor = [UIColor cyanColor];
	
	// using auto-layout
	self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// create botView
	self.outputView = [CanvasView new];
	self.outputView.backgroundColor = [UIColor yellowColor];
	
	// using auto-layout
	self.outputView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// create containerView
	self.containerView = [UIView new];
	self.containerView.backgroundColor = [UIColor orangeColor];
	
	// using auto-layout
	self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// add botView to containerView
	[self.containerView addSubview:self.outputView];
	
	// add views to self.view
	[self.view addSubview:self.inputView];
	[self.view addSubview:self.containerView];
	
	// respect safeArea
	UILayoutGuide *g = self.view.safeAreaLayoutGuide;
	
	[NSLayoutConstraint activateConstraints:@[
		
		// constrain topView to safeArea Top + 8-pts
		[self.inputView.topAnchor constraintEqualToAnchor:g.topAnchor constant:8.0],
		
		// constrain topView centerX
		[self.inputView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		
		// constrain topView Width, Height
		[self.inputView.widthAnchor constraintEqualToConstant:inputWidth],
		[self.inputView.heightAnchor constraintEqualToConstant:inputHeight],
		
		// constrain containerView Top to topView Bottom + 20-pts
		[self.containerView.topAnchor constraintEqualToAnchor:self.inputView.bottomAnchor constant:20.0],
		
		// constrain containerView centerX to topView centerX
		[self.containerView.centerXAnchor constraintEqualToAnchor:self.inputView.centerXAnchor],
		
		// constrain containerView Width, Height
		[self.containerView.widthAnchor constraintEqualToConstant:outputWidth],
		[self.containerView.heightAnchor constraintEqualToConstant:outputHeight],
		
		// constrain botView centerX, centerY to containerView centerX, centerY
		[self.outputView.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
		[self.outputView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
		
		// constrain botView Width, Height to same as topView
		[self.outputView.widthAnchor constraintEqualToConstant:inputWidth],
		[self.outputView.heightAnchor constraintEqualToConstant:inputHeight],
		
	]];
	
	// target scaled size for botView
	CGFloat wScale = outputWidth / inputWidth;
	CGFloat hScale = outputHeight / inputHeight;
	
	// scale the bottom view
	CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, wScale, hScale);
	[self.outputView setTransform:t];
	
	// allow drawing on the top view
	[self.inputView enableDrawing:YES];
	
	// don't allow drawing on the bottom view
	// (also sets the bottom view as the notification receiver)
	[self.outputView enableDrawing:NO];
	
}

- (void)setupWithoutContainer {
	
	// create topView
	self.inputView = [CanvasView new];
	self.inputView.backgroundColor = [UIColor cyanColor];
	
	// using auto-layout
	self.inputView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// create botView
	self.outputView = [CanvasView new];
	self.outputView.backgroundColor = [UIColor yellowColor];
	
	// using auto-layout
	self.outputView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// add views to self.view
	[self.view addSubview:self.inputView];
	[self.view addSubview:self.outputView];
	
	// respect safeArea
	UILayoutGuide *g = self.view.safeAreaLayoutGuide;
	
	[NSLayoutConstraint activateConstraints:@[
		
		// constrain topView to safeArea Top + 8-pts
		[self.inputView.topAnchor constraintEqualToAnchor:g.topAnchor constant:8.0],
		
		// constrain topView centerX
		[self.inputView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		
		// constrain topView Width, Height
		[self.inputView.widthAnchor constraintEqualToConstant:inputWidth],
		[self.inputView.heightAnchor constraintEqualToConstant:inputHeight],
		
		// constrain botView Top to topView Bottom + 20-pts
		[self.outputView.topAnchor constraintEqualToAnchor:self.inputView.bottomAnchor constant:20.0],
		
		// constrain botView centerX to topView centerX
		[self.outputView.centerXAnchor constraintEqualToAnchor:self.inputView.centerXAnchor],
		
		// constrain botView Width, Height to same as topView
		[self.outputView.widthAnchor constraintEqualToConstant:inputWidth],
		[self.outputView.heightAnchor constraintEqualToConstant:inputHeight],
		
	]];
	
	// target scaled size for botView
	CGFloat wScale = outputWidth / inputWidth;
	CGFloat hScale = outputHeight / inputHeight;
	
	// CGAffineTransformScale scales from the center of the view (0.5,0.5)
	// so calculate anchor point to keep the top at its original position
	// if our views are not horizontally centered, we'd also need to calculate
	// the xAnchor adjustment
	CGFloat yAnchor = 0.5 / hScale;
	[self.outputView.layer setAnchorPoint:CGPointMake(0.5, yAnchor)];
	
	// scale the bottom view
	CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, wScale, hScale);
	[self.outputView setTransform:t];
	
	// allow drawing on the top view
	[self.inputView enableDrawing:YES];
	
	// don't allow drawing on the bottom view
	// (also sets the bottom view as the notification receiver)
	[self.outputView enableDrawing:NO];
	
}

@end
