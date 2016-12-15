@import UIKit;

@protocol ResizableDynamicItem <UIDynamicItem>
@property (nonatomic, readwrite) CGRect bounds;
@end


@interface PositionToBoundsMapping : NSObject <UIDynamicItem>

- (instancetype)initWithTarget:(id)target;

@end
