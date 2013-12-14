//
//  MLViewController.m
//  PauseAnimation
//
//  Created by Matt Long on 12/14/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import "MLViewController.h"

@interface MLViewController ()

@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) CABasicAnimation *drawAnimation;

@end

@implementation MLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int radius = 30;
    _circle = [CAShapeLayer layer];
    // Make a circular shape
    _circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 100, 2.0*radius, 2.0*radius)
                                              cornerRadius:radius].CGPath;
    // Center the shape in self.view
    _circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                   CGRectGetMidY(self.view.frame)-radius);
    
    // Configure the apperence of the circle
    _circle.fillColor = [UIColor lightGrayColor].CGColor;
    _circle.strokeColor = [UIColor orangeColor].CGColor;
    _circle.lineWidth = 10;
    
    _circle.strokeEnd = 0.0f;
    
    // Add to parent layer
    [self.view.layer addSublayer:_circle];

}

- (IBAction)didTapPlayPauseButton:(id)sender
{
    if (!_drawAnimation) {
        [self addAnimation];
    } else if(_circle.speed == 0){
        [self resumeLayer:_circle];
    } else {
        [self pauseLayer:_circle];
    }
    
}

- (void)addAnimation
{
    // Configure animation
    _drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    _drawAnimation.duration            = 30.0; // "animate over 10 seconds or so.."
    _drawAnimation.repeatCount         = 1.0;  // Animate only once..
    _drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation...
    
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    _drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    _drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    _drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [_circle addAnimation:_drawAnimation forKey:@"drawCircleAnimation"];
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
