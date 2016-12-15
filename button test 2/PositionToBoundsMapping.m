
#import "PositionToBoundsMapping.h"

@interface PositionToBoundsMapping ()
@property (nonatomic, strong) id<ResizableDynamicItem> target;
@end


@implementation PositionToBoundsMapping

//| ----------------------------------------------------------------------------
- (instancetype)initWithTarget:(id)target
{
    self = [super init];
    if (self)
    {
        _target = target;
    }
    return self;
}

#pragma mark -
#pragma mark UIDynamicItem

- (CGRect)bounds
{
    return self.target.bounds;
}

- (CGPoint)center
{
    // center.x <- bounds.size.width, center.y <- bounds.size.height
    return CGPointMake(self.target.bounds.size.width, self.target.bounds.size.height);
}

- (void)setCenter:(CGPoint)center
{
    // center.x -> bounds.size.width, center.y -> bounds.size.height
    self.target.bounds = CGRectMake(0, 0, center.x, center.y);
}

- (CGAffineTransform)transform
{
    return self.target.transform;
}

- (void)setTransform:(CGAffineTransform)transform
{
    self.target.transform = transform;
}

@end
