//
//  CanvasDemoViewController.m
//  CanvasDraw
//
//  Created by Don Mag on 3/18/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

#import "CanvasDemoViewController.h"
#import "CanvasView.h"

@interface CanvasDemoViewController ()

@property (strong, nonatomic) CanvasView *topView;
@property (strong, nonatomic) CanvasView *botView;

@property (strong, nonatomic) UIView *containerView;

@end

CGFloat topWidth = 300.0;
CGFloat topHeight = 400.0;

CGFloat botWidth = 150.0;
CGFloat botHeight = 240.0;

@implementation CanvasDemoViewController

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
	self.topView = [CanvasView new];
	self.topView.backgroundColor = [UIColor cyanColor];
	
	// using auto-layout
	self.topView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// create botView
	self.botView = [CanvasView new];
	self.botView.backgroundColor = [UIColor yellowColor];
	
	// using auto-layout
	self.botView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// create containerView
	self.containerView = [UIView new];
	self.containerView.backgroundColor = [UIColor orangeColor];
	
	// using auto-layout
	self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// add botView to containerView
	[self.containerView addSubview:self.botView];
	
	// add views to self.view
	[self.view addSubview:self.topView];
	[self.view addSubview:self.containerView];
	
	// respect safeArea
	UILayoutGuide *g = self.view.safeAreaLayoutGuide;
	
	[NSLayoutConstraint activateConstraints:@[
		
		// constrain topView to safeArea Top + 8-pts
		[self.topView.topAnchor constraintEqualToAnchor:g.topAnchor constant:8.0],
		
		// constrain topView centerX
		[self.topView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		
		// constrain topView Width, Height
		[self.topView.widthAnchor constraintEqualToConstant:topWidth],
		[self.topView.heightAnchor constraintEqualToConstant:topHeight],
		
		// constrain containerView Top to topView Bottom + 8-pts
		[self.containerView.topAnchor constraintEqualToAnchor:self.topView.bottomAnchor constant:8.0],
		
		// constrain containerView centerX to topView centerX
		[self.containerView.centerXAnchor constraintEqualToAnchor:self.topView.centerXAnchor],
		
		// constrain containerView Width, Height
		[self.containerView.widthAnchor constraintEqualToConstant:botWidth],
		[self.containerView.heightAnchor constraintEqualToConstant:botHeight],
		
		// constrain botView centerX, centerY to containerView centerX, centerY
		[self.botView.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor],
		[self.botView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor],
		
		// constrain botView Width, Height to same as topView
		[self.botView.widthAnchor constraintEqualToConstant:topWidth],
		[self.botView.heightAnchor constraintEqualToConstant:topHeight],
		
	]];
	
	// target scaled size for botView
	CGFloat wScale = botWidth / topWidth;
	CGFloat hScale = botHeight / topHeight;
	
	// scale the bottom view
	CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, wScale, hScale);
	[self.botView setTransform:t];
	
	// allow drawing on the top view
	[self.topView enableDrawing:YES];
	
	// don't allow drawing on the bottom view
	// (also sets the bottom view as the notification receiver)
	[self.botView enableDrawing:NO];
	
}

- (void)setupWithoutContainer {
	
	// create topView
	self.topView = [CanvasView new];
	self.topView.backgroundColor = [UIColor cyanColor];
	
	// using auto-layout
	self.topView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// create botView
	self.botView = [CanvasView new];
	self.botView.backgroundColor = [UIColor yellowColor];
	
	// using auto-layout
	self.botView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// add views to self.view
	[self.view addSubview:self.topView];
	[self.view addSubview:self.botView];
	
	// respect safeArea
	UILayoutGuide *g = self.view.safeAreaLayoutGuide;
	
	[NSLayoutConstraint activateConstraints:@[
		
		// constrain topView to safeArea Top + 8-pts
		[self.topView.topAnchor constraintEqualToAnchor:g.topAnchor constant:8.0],
		
		// constrain topView centerX
		[self.topView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		
		// constrain topView Width, Height
		[self.topView.widthAnchor constraintEqualToConstant:topWidth],
		[self.topView.heightAnchor constraintEqualToConstant:topHeight],
		
		// constrain botView Top to topView Bottom + 20-pts
		[self.botView.topAnchor constraintEqualToAnchor:self.topView.bottomAnchor constant:20.0],
		
		// constrain botView centerX to topView centerX
		[self.botView.centerXAnchor constraintEqualToAnchor:self.topView.centerXAnchor],
		
		// constrain botView Width, Height to same as topView
		[self.botView.widthAnchor constraintEqualToConstant:topWidth],
		[self.botView.heightAnchor constraintEqualToConstant:topHeight],
		
	]];
	
	// target scaled size for botView
	CGFloat wScale = botWidth / topWidth;
	CGFloat hScale = botHeight / topHeight;
	
	// CGAffineTransformScale scales from the center of the view (0.5,0.5)
	// so calculate anchor point to keep the top at its original position
	// if our views are not horizontally centered, we'd also need to calculate
	// the xAnchor adjustment
	CGFloat yAnchor = 0.5 / hScale;
	[self.botView.layer setAnchorPoint:CGPointMake(0.5, yAnchor)];
	
	// scale the bottom view
	CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, wScale, hScale);
	[self.botView setTransform:t];
	
	// allow drawing on the top view
	[self.topView enableDrawing:YES];
	
	// don't allow drawing on the bottom view
	// (also sets the bottom view as the notification receiver)
	[self.botView enableDrawing:NO];
	
}

@end
