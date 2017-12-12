/*
 Copyright 2017-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "MDMSpringTimingCurve.h"

#import <UIKit/UIKit.h>

@implementation MDMSpringTimingCurve {
  CGFloat _duration;
  CGFloat _dampingRatio;

  BOOL _coefficientsAreInvalid;
}

@synthesize mass = _mass;
@synthesize friction = _friction;
@synthesize tension = _tension;

- (instancetype)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (instancetype)initWithDuration:(NSTimeInterval)duration dampingRatio:(CGFloat)dampingRatio {
  return [self initWithDuration:duration dampingRatio:dampingRatio initialVelocity:0];
}

- (nonnull instancetype)initWithDuration:(NSTimeInterval)duration
                            dampingRatio:(CGFloat)dampingRatio
                         initialVelocity:(CGFloat)initialVelocity {
  self = [self initWithMass:0 tension:0 friction:0 initialVelocity:initialVelocity];
  if (self) {
    _duration = duration;
    _dampingRatio = dampingRatio;
    _coefficientsAreInvalid = YES;
  }
  return self;
}

- (instancetype)initWithMass:(CGFloat)mass tension:(CGFloat)tension friction:(CGFloat)friction {
  return [self initWithMass:mass tension:tension friction:friction initialVelocity:0];
}

- (instancetype)initWithMass:(CGFloat)mass
                     tension:(CGFloat)tension
                    friction:(CGFloat)friction
             initialVelocity:(CGFloat)initialVelocity {
  self = [super init];
  if (self) {
    _mass = mass;
    _tension = tension;
    _friction = friction;
    _initialVelocity = initialVelocity;
  }
  return self;
}

- (CGFloat)mass {
  [self recalculateCoefficientsIfNeeded];
  return _mass;
}

- (CGFloat)tension {
  [self recalculateCoefficientsIfNeeded];
  return _tension;
}

- (CGFloat)friction {
  [self recalculateCoefficientsIfNeeded];
  return _friction;
}

- (void)setInitialVelocity:(CGFloat)initialVelocity {
  _initialVelocity = initialVelocity;

  _coefficientsAreInvalid = YES;
}

#pragma mark - Private

- (void)recalculateCoefficientsIfNeeded {
  if (_coefficientsAreInvalid) {
    [self recalculateCoefficients];
  }
}

- (void)recalculateCoefficients {
  UIView *view = [[UIView alloc] init];
  [UIView animateWithDuration:_duration
                        delay:0
       usingSpringWithDamping:_dampingRatio
        initialSpringVelocity:self.initialVelocity
                      options:0
                   animations:^{
                     view.center = CGPointMake(100, 100);
                   } completion:nil];

  NSString *animationKey = [view.layer.animationKeys firstObject];
  NSAssert(animationKey != nil, @"Unable to extract animation timing curve: no animation found.");
#pragma clang diagnostic push
  // CASpringAnimation is a private API on iOS 8 - we're able to make use of it because we're
  // linking against the public API on iOS 9+.
#pragma clang diagnostic ignored "-Wpartial-availability"
  CASpringAnimation *springAnimation =
      (CASpringAnimation *)[view.layer animationForKey:animationKey];
  NSAssert([springAnimation isKindOfClass:[CASpringAnimation class]],
           @"Unable to extract animation timing curve: unexpected animation type.");
#pragma clang diagnostic pop

  _mass = springAnimation.mass;
  _tension = springAnimation.stiffness;
  _friction = springAnimation.damping;

  _coefficientsAreInvalid = NO;
}

@end

