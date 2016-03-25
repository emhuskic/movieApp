//
//  LoadingView.m
//  movieApp
//
//  Created by Adis Cehajic on 25/03/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView
+ (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 0.5f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}

+ (void)stopRotateLayerInfinite:(CALayer *)layer
{
    [layer removeAllAnimations];
}
@end
