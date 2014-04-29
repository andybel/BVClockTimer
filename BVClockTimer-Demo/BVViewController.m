//
//  BVViewController.m
//  BVClockTimer-Demo
//
//  Created by Andy Bell on 29/04/2014.
//  Copyright (c) 2014 Andy Bell. All rights reserved.
//

#import "BVViewController.h"
#import "BVClockTimer.h"

@interface BVViewController ()<BVClockTimerDelegate>

@property (nonatomic, strong) BVClockTimer *clock;
@property (nonatomic, strong) NSDate *start, *end;

@end

@implementation BVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 330, 100, 40)];
    [startBtn setBackgroundColor:[UIColor blackColor]];
    [startBtn setTitle:@"Go!" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    self.clock = [[BVClockTimer alloc] initWithFrame:CGRectMake(30, 50, 244, 244)];
    [self.clock setCircleColour:[UIColor redColor]];
    [self.clock setLineWidth:12.0];
    [self.clock setRotateClockwise:NO];
    self.clock.delegate = self;
    [self.view addSubview:self.clock];
    
}

-(IBAction)start:(id)sender {
    self.start = [NSDate date];
    [self.clock beginAnimationWithDuration:4.0];
}

#pragma mark - BVCClockTimerDelegate methods
-(void)clockTimerDidComplete {
    
    self.end = [NSDate date];
    NSString *timerMsg = [NSString stringWithFormat:@"Clock completed in %.1f seconds.", [self.end timeIntervalSinceDate:self.start]];
    
    UIAlertView *completeAlert = [[UIAlertView alloc] initWithTitle:@"Completed"
                                                            message:timerMsg
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
    [completeAlert show];
    
}

-(void)clockTimerDidStop {
    NSLog(@"clockTimerDidStop");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
