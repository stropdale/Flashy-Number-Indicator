//
//  CircularLabel.m
//  button test 2
//
//  Created by Stockdale, Richard on 25/11/2015.
//  Copyright © 2015 Stockdale, Richard. All rights reserved.
//

#import "CircularView.h"
#import <QuartzCore/QuartzCore.h>

@interface CircularView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *color;

@end

@implementation CircularView

- (instancetype)initWithFrame:(CGRect)frame andColor : (UIColor *) color
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawPositiveColorBadge:rect];
}

- (void) drawPositiveColorBadge : (CGRect) rect {
    float xInset = rect.size.width / 15;
    float yInset = rect.size.height / 15;
    
    CGRect adjustedFrame = CGRectMake(xInset, yInset, rect.size.width - (xInset * 2), rect.size.height - (xInset * 2));
    
    self.path = [UIBezierPath bezierPathWithOvalInRect:adjustedFrame];
    
    [self.color setFill];
    [self.path fill];
    self.backgroundColor = [UIColor clearColor];
}

@end
