//
//  DZRoundProgressView.m
//  BVClock
//
//  Created by Andy Bell on 25/04/2014.
//  Copyright (c) 2014 Andy Bell. All rights reserved.
//

#import "BVClockTimer.h"
#import <QuartzCore/QuartzCore.h>

@interface BVClockTimerLayer : CALayer

@property (nonatomic) CGFloat layerprogress;
@property (nonatomic) float animDuration;
@property (nonatomic, strong) BVClockTimer *parentView;

@end

@implementation BVClockTimerLayer

@dynamic layerprogress;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"layerprogress"] || [super needsDisplayForKey:key];
}

- (id)actionForKey:(NSString *) aKey {
    if ([aKey isEqualToString:@"layerprogress"]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:aKey];
        animation.fromValue = [self.presentationLayer valueForKey:aKey];
        animation.duration = self.animDuration;
        animation.delegate = self.parentView;
        return animation;
    }
    return [super actionForKey:aKey];
}

- (void)drawInContext:(CGContextRef)context {
    
    if (!self.parentView) {
        self.parentView = self.delegate;
    }
    
    CGRect circleRect = CGRectInset(self.bounds, 1, 1);
    
    CGFloat startAngle = -M_PI / 2;
    double pieForEnd = (self.parentView.rotateClockwise) ? M_PI : -M_PI;
    CGFloat endAngle = ((self.layerprogress * 2) * pieForEnd) + startAngle;
    
    CGColorRef circColour = self.parentView.circleColour.CGColor;
    
    CGPoint center = CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect));
    
    // Draw the White Line
    CGFloat lineWidth = self.parentView.lineWidth;
    CGFloat circRadius = CGRectGetMidX(circleRect) - (lineWidth / 2);// * 0.72;
    
    CGContextSetStrokeColorWithColor(context, circColour);
    CGContextSetFillColorWithColor(context, circColour);
    
    CGContextMoveToPoint(context, center.x, center.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, lineWidth);
    
    CGPathAddArc(path, NULL, center.x, center.y, circRadius, startAngle, endAngle, 0);
    CGContextAddPath(context, path);
    
    CGContextStrokePath(context);
    
    // This line causes error (<Error>: CGContextClosePath: no current point.) - is it even needed?
    //CGContextClosePath(context);
    CGContextFillPath(context);
    
    [super drawInContext:context];
}

@end

@implementation BVClockTimer

+ (Class)layerClass {
    return [BVClockTimerLayer class];
}

- (id)init {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 137.0f, 137.0f)];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        self.backgroundColor = [UIColor purpleColor];
        
        self.lineWidth = 30.0f;
        self.circleColour = [UIColor whiteColor];
        self.rotateClockwise = YES;
        
        self.opaque = NO;
        self.layer.delegate = self;
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer setNeedsDisplay];
    }
    return self;
}

-(void)beginAnimationWithDuration:(float)dur {
    
    BVClockTimerLayer *clockLayer = (BVClockTimerLayer *)self.layer;
    clockLayer.parentView = self;
    clockLayer.animDuration = dur;
    clockLayer.layerprogress = 1.0;
    
}

-(void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"animation did start.");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self.delegate clockTimerDidComplete];
    }else{
        [self.delegate clockTimerDidStop];
    }
}

@end
