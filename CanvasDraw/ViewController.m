//
//  ViewController.m
//  CanvasDraw
//
//  Created by Don Mag on 3/18/20.
//  Copyright © 2020 Don Mag. All rights reserved.
//

#import "ViewController.h"
#import "TransformScaleViewController.h"
#import "TranslateCoordsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)tranformScaleTapped:(id)sender {
	TransformScaleViewController *vc = [TransformScaleViewController new];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)translateCoordsTapped:(id)sender {
	TranslateCoordsViewController *vc = [TranslateCoordsViewController new];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
