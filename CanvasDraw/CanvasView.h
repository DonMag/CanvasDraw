//
//  CanvasView.h
//  Created by Don Mag on 2/27/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CanvasView : UIView

@property (assign, readwrite) BOOL bTranslateCoordinates;

- (void)enableDrawing:(BOOL)b;

@end

NS_ASSUME_NONNULL_END
