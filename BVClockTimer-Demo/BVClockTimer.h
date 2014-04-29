//
//  DZRoundProgressView.h
//  BVClock
//
//  Created by Andy Bell on 25/04/2014.
//  Copyright (c) 2014 Andy Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BVClockTimerDelegate <NSObject>

@optional
-(void)clockTimerDidComplete;
-(void)clockTimerDidStop;

@end

@interface BVClockTimer : UIView

@property (weak, nonatomic) id<BVClockTimerDelegate>delegate;
@property (nonatomic, strong) UIColor *circleColour;
@property (nonatomic) float lineWidth;
@property (nonatomic) BOOL rotateClockwise;

-(void)beginAnimationWithDuration:(float)dur;

@end
