//
//  BetSlipIndicatorView.m
//  button test 2
//
//  Created by Stockdale, Richard on 25/11/2015.
//  Copyright © 2015 Stockdale, Richard. All rights reserved.
//

#import "BetSlipIndicatorView.h"
#import "CircularView.h"
#import "PositionToBoundsMapping.h"
#import <QuartzCore/QuartzCore.h>


@interface BetSlipIndicatorView ()

@property (nonatomic, strong) CircularView *positiveNumberView;
@property (nonatomic, strong) CircularView *zeroNumberView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, readwrite) CGRect cViewOriginalBounds;

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *animationLabel;

@property (nonatomic) CGRect labelOnScreenFrame;
@property (nonatomic) CGRect labelAboveScreenFrame;
@property (nonatomic) CGRect labelBelowScreenFrame;

@property (nonatomic) NSInteger lastNumber;


@end

@implementation BetSlipIndicatorView

// UIDynamics Constants
static float pumpFrequency = 1.3;
static float pumpDampening = 0.13;
static float pumpMagnitude = -3.2;

// Label Animation Constants
static float animationDuration = 0.5;
static float animationStartDelay = 0.4;
static float springDampening = 0.6;
static float initialSpringVelocity = 0.5;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 40;
        _lastNumber = 0;
        _indicatorValue = 0;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [self bouncingCircularViewWithBounds:frame];
        [self setUpLabels];
    }
    return self;
}

#pragma mark - Value Indicator

- (void) setUpLabels {
    
    self.labelOnScreenFrame =  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.labelBelowScreenFrame =  CGRectMake(0, self.frame.size.height - 10, self.positiveNumberView.bounds.size.width, self.bounds.size.height);
    self.labelAboveScreenFrame = CGRectMake(0, 0 - (self.frame.size.height - 10), self.positiveNumberView.bounds.size.width, self.bounds.size.height);
    
    if (!self.valueLabel) {
        self.valueLabel = [[UILabel alloc] initWithFrame: self.labelOnScreenFrame];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.font = [UIFont systemFontOfSize:self.fontSize];
        self.valueLabel.text = @"0";
        self.valueLabel.textColor = [UIColor redColor];
        [self addSubview:self.valueLabel];
    }
    if (!self.animationLabel) {
        self.animationLabel = [[UILabel alloc] initWithFrame: self.labelBelowScreenFrame];
        self.animationLabel.textAlignment = NSTextAlignmentCenter;
        self.animationLabel.font = [UIFont systemFontOfSize:self.fontSize];
        self.animationLabel.text = @"0";
        self.animationLabel.textColor = [UIColor redColor];
        [self addSubview:self.animationLabel];
    }
}

- (void) setIndicatorValue : (NSInteger) value {
    
    if (value == 0) {
        [self backGroundToZeroColor];
    }
    else {
        if (self.lastNumber == 0) {
            [self backGroundToHasBetsColor];
        }
    }
    
    [self pumpCircularView];
    [self animateNumberTransition:value];
    self.lastNumber = value;
}

- (void) backGroundToZeroColor {
    [UIView animateWithDuration:0.3 animations:^{
        self.zeroNumberView.alpha = 1.0;
        self.positiveNumberView.alpha = 0.0;
    }];
}

- (void) backGroundToHasBetsColor {
    [UIView animateWithDuration:0.3 animations:^{
        self.zeroNumberView.alpha = 0.0;
        self.positiveNumberView.alpha = 1.0;
    }];
    
}

- (void) setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
}

- (void) animateNumberTransition : (NSInteger) value
{
    self.lastNumber < value ? [self flickNumberUp:value] : [self flickNumberDown:value];
}

#pragma mark - Move Label Up

- (void) flickNumberUp : (NSInteger) value {
    self.animationLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
    
    [UIView animateWithDuration:animationDuration
                          delay:animationStartDelay
         usingSpringWithDamping:springDampening
          initialSpringVelocity:initialSpringVelocity
                        options:UIViewAnimationOptionTransitionNone animations:^{
                            self.valueLabel.frame = self.labelAboveScreenFrame;;
                        } completion:^(BOOL finished) {
                            [self moveAnimationLabelUpScreen:value];
                        }];
}

- (void) moveAnimationLabelUpScreen : (NSInteger) value {
    [UIView animateWithDuration:animationDuration
                          delay:0.0
         usingSpringWithDamping:springDampening
          initialSpringVelocity:initialSpringVelocity
                        options:UIViewAnimationOptionTransitionNone animations:^{
                            self.animationLabel.frame = self.labelOnScreenFrame;
                        } completion:^(BOOL finished) {
                            self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
                            [self resetLabelPositions];
                        }];
}

#pragma mark - Move Label Down

- (void) flickNumberDown : (NSInteger) value {
    [self moveLabelsReadyForDownAnimation];
    self.animationLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
    
    [UIView animateWithDuration:animationDuration
                          delay:animationStartDelay
         usingSpringWithDamping:springDampening
          initialSpringVelocity:initialSpringVelocity
                        options:UIViewAnimationOptionTransitionNone animations:^{
                            self.valueLabel.frame = self.labelBelowScreenFrame;
                        } completion:^(BOOL finished) {
                            [self moveAnimationLabelDownScreen:value];
                        }];
}

- (void) moveAnimationLabelDownScreen : (NSInteger) value {
    [UIView animateWithDuration:animationDuration
                          delay:0.0
         usingSpringWithDamping:springDampening
          initialSpringVelocity:initialSpringVelocity
                        options:UIViewAnimationOptionTransitionNone animations:^{
                            self.animationLabel.frame = self.labelOnScreenFrame;
                        } completion:^(BOOL finished) {
                            self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
                            [self resetLabelPositions];
                        }];
}

- (void) moveLabelsReadyForDownAnimation
{
    self.valueLabel.frame = self.labelOnScreenFrame;
    self.animationLabel.frame = self.labelAboveScreenFrame;
}

- (void) resetLabelPositions {
    self.valueLabel.frame = self.labelOnScreenFrame;
    self.animationLabel.frame = self.labelBelowScreenFrame;
}

#pragma mark - Pump Circle

- (void) bouncingCircularViewWithBounds : (CGRect) bounds
{
    CGRect viewRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.positiveNumberView = [[CircularView alloc] initWithFrame:viewRect andColor:[UIColor orangeColor]];
    self.zeroNumberView= [[CircularView alloc] initWithFrame:viewRect andColor:[UIColor grayColor]];
    
    // Keep a record of the original size
    self.cViewOriginalBounds = self.positiveNumberView.bounds;
    
    self.positiveNumberView.backgroundColor = [UIColor clearColor];
    self.zeroNumberView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.positiveNumberView];
    [self addSubview:self.zeroNumberView];
    
}

- (void) pumpCircularView
{
    self.positiveNumberView.bounds = self.cViewOriginalBounds;
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    PositionToBoundsMapping *pBoundsDynamicItem = [[PositionToBoundsMapping alloc] initWithTarget:self.positiveNumberView];
    PositionToBoundsMapping *zBoundsDynamicItem = [[PositionToBoundsMapping alloc] initWithTarget:self.zeroNumberView];
    
    UIAttachmentBehavior *pViewAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:pBoundsDynamicItem attachedToAnchor:pBoundsDynamicItem.center];
    UIAttachmentBehavior *zViewAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:zBoundsDynamicItem attachedToAnchor:zBoundsDynamicItem.center];
    pViewAttachmentBehavior.frequency = pumpFrequency;
    pViewAttachmentBehavior.damping = pumpDampening;
    zViewAttachmentBehavior.frequency = pumpFrequency;
    zViewAttachmentBehavior.damping = pumpDampening;
    
    [animator addBehavior:pViewAttachmentBehavior];
    [animator addBehavior:zViewAttachmentBehavior];
    
    UIPushBehavior *pumpBehavior = [[UIPushBehavior alloc] initWithItems:@[pBoundsDynamicItem, zBoundsDynamicItem] mode:UIPushBehaviorModeInstantaneous];
    pumpBehavior.angle = M_PI_4;
    pumpBehavior.magnitude = pumpMagnitude;
    [animator addBehavior:pumpBehavior];
    [pumpBehavior setActive:TRUE];

    self.animator = animator;
}

@end
