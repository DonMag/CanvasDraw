//
//  CanvasView.m
//  Created by Don Mag on 2/27/20.
//

#import "CanvasView.h"

@interface CanvasView()

@property (strong, nonatomic) NSMutableArray *pointArrays;
@property (assign, readwrite) BOOL isDrawSelected;

@end

@implementation CanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void) commonInit {
	_pointArrays = [NSMutableArray array];
	_isDrawSelected = NO;
}

-(void)drawRect:(CGRect)rect {
	// Drawing code
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 5);
	CGContextSetLineCap(context, kCGLineCapButt);

	for (NSDictionary *pointdict in _pointArrays) {
		
		CGFloat xScale = 1.0;
		CGFloat yScale = 1.0;
		
		CGSize sourceSize = [pointdict[@"size"] CGSizeValue];
		
		// if sourceSize == CGSizeZero, we are actively drawing
		//	else, we were sent points (and a size) from "the other guy"
		if (!CGSizeEqualToSize(sourceSize, CGSizeZero)) {
			
			// calculate scaling based on selfSize : sourceSize
			xScale = self.bounds.size.width / sourceSize.width;
			yScale = self.bounds.size.height / sourceSize.height;
		
			// scale the lineWidth (if desired)
			CGContextSetLineWidth(context, 5.0 * MIN(xScale, yScale));
		}
		
		if([pointdict[@"point"] isKindOfClass:[NSArray class]]){
			UIColor *clo = (UIColor*)pointdict[@"color"];
			CGContextSetStrokeColorWithColor(context, clo.CGColor);
			[pointdict[@"point"] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
				CGPoint point = [object CGPointValue];
				point.x *= xScale;
				point.y *= yScale;
				if(idx == 0){
					CGContextMoveToPoint(context, point.x, point.y);
				}else{
					CGContextAddLineToPoint(context, point.x, point.y);
				}
			}];
			CGContextStrokePath(context);
		}
	}

	return;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint point = [touch locationInView:self];
	if(_isDrawSelected){
		NSDictionary *dict = @{@"color" : [self getSelectedColor],
							   @"point" : @[[NSValue valueWithCGPoint:point]],
							   @"Isedited" : @NO
		};
		[_pointArrays addObject:dict];
	}
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	if(_isDrawSelected){
		NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
		NSDictionary* points = [[_pointArrays lastObject] mutableCopy];
		if([points[@"point"] isKindOfClass:[NSArray class]]){
			for (id po in points[@"point"]) {
				[pointArray addObject:po];
			}
		}
		[_pointArrays removeLastObject];
		[pointArray addObject:[NSValue valueWithCGPoint:point]];
		[points setValue:pointArray forKey:@"point"];
		[_pointArrays addObject:points];
		pointArray = nil;
		points = nil;
		[self setNeedsDisplay];
	}
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if(_isDrawSelected){
		// Sending Notification to other view
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:@"kreannotatePoint"
		 object:nil
		 userInfo:@{
			 @"drowPoint" : [_pointArrays lastObject],
			 @"size" : @(self.bounds.size)
		 }];
	}
}

// for demo purposes, just return red
- (UIColor *)getSelectedColor {
	return [UIColor redColor];
}

// for demo purposes, just return blue
- (UIColor *)getcolorFromString:(NSString *)v {
	return [UIColor blueColor];
}

-(void)updateReannotation:(NSNotification * _Nonnull)notif {
	
	NSDictionary *value = notif.userInfo[@"drowPoint"];
	
	id sz = notif.userInfo[@"size"];
	
	NSDictionary *dict = @{
		@"color" : [self getcolorFromString:value[@"color"]],
		@"point" : value[@"point"],
		@"size" : sz,
		@"Isedited" : @NO
	};
	
	[_pointArrays addObject:dict];
	
	[self setNeedsDisplay];
	
}

- (void)enableDrawing:(BOOL)b {
	_isDrawSelected = b;
	if (!_isDrawSelected) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReannotation:) name:@"kreannotatePoint" object:nil];
	}
}

@end
