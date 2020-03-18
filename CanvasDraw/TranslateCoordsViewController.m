//
//  TranslateCoordsViewController.m
//  CanvasDraw
//
//  Created by Don Mag on 3/18/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

#import "TranslateCoordsViewController.h"
#import "Sizes.h"
#import "CanvasView.h"

@interface TranslateCoordsViewController ()

@property (strong, nonatomic) CanvasView *inputView;
@property (strong, nonatomic) CanvasView *outputView;

@end

@implementation TranslateCoordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor greenColor];

	[self setupViews];
	
}

- (void)setupViews {
	
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
		
		// constrain inputView to safeArea Top + 8-pts
		[self.inputView.topAnchor constraintEqualToAnchor:g.topAnchor constant:8.0],
		
		// constrain inputView centerX
		[self.inputView.centerXAnchor constraintEqualToAnchor:g.centerXAnchor],
		
		// constrain inputView Width, Height
		[self.inputView.widthAnchor constraintEqualToConstant:inputWidth],
		[self.inputView.heightAnchor constraintEqualToConstant:inputHeight],
		
		// constrain outputView Top to topView Bottom + 20-pts
		[self.outputView.topAnchor constraintEqualToAnchor:self.inputView.bottomAnchor constant:20.0],
		
		// constrain outputView centerX to topView centerX
		[self.outputView.centerXAnchor constraintEqualToAnchor:self.inputView.centerXAnchor],
		
		// constrain outputView Width, Height
		[self.outputView.widthAnchor constraintEqualToConstant:outputWidth],
		[self.outputView.heightAnchor constraintEqualToConstant:outputHeight],
		
	]];
	
	// allow drawing on the input view
	[self.inputView enableDrawing:YES];
	
	// don't allow drawing on the output view
	// (also sets the bottom view as the notification receiver)
	[self.outputView enableDrawing:NO];
	
}

@end
