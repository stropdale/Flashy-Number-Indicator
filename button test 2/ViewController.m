//
//  ViewController.m
//  button test 2
//
//  Created by Stockdale, Richard on 25/11/2015.
//  Copyright © 2015 Stockdale, Richard. All rights reserved.
//

#import "ViewController.h"
#import "PositionToBoundsMapping.h"
#import "BetSlipIndicatorView.h"

@interface ViewController ()
{
    NSInteger tempVal;
}

@property (nonatomic, strong) BetSlipIndicatorView *indicator;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indicator = [[BetSlipIndicatorView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    [self.view addSubview:self.indicator];
    
    tempVal = 0;
}

- (IBAction)buttonTapped:(id)sender
{
    tempVal--;
    [self.indicator setIndicatorValue:tempVal];
    //[self.indicator pumpCircularView];
}

- (IBAction)plusTapped:(id)sender {
    tempVal++;
    [self.indicator setIndicatorValue:tempVal];
}
@end
