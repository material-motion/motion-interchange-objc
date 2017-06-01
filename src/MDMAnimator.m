/*
 Copyright 2017-present the Material Components for iOS authors. All Rights Reserved.

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

#import "MDMAnimator.h"

const MDMMotionTiming MDMMotionTimingInstantaneous = {
  .duration = 0,
  .delay = 0,
  .curve = {
    .type = MDMMotionCurveTypeInstant,
    .data = {0, 0, 0, 0}
  }
};

const MDMMotionTiming MDMMotionTimingDefault = {
  .duration = 0,
  .delay = 0,
  .curve = {
    .type = MDMMotionCurveTypeDefault,
    .data = {0, 0, 0, 0}
  }
};

#if TARGET_IPHONE_SIMULATOR
UIKIT_EXTERN float UIAnimationDragCoefficient(void); // UIKit private drag coefficient.
#endif

static CGFloat simulatorAnimationDragCoefficient(void) {
#if TARGET_IPHONE_SIMULATOR
  return UIAnimationDragCoefficient();
#else
  return 1.0;
#endif
}

static CAMediaTimingFunction* timingFunctionWithControlPoints(CGFloat controlPoints[4]) {
  return [CAMediaTimingFunction functionWithControlPoints:(float)controlPoints[0]
                                                         :(float)controlPoints[1]
                                                         :(float)controlPoints[2]
                                                         :(float)controlPoints[3]];
}

@interface MDMAnimatorStatesStorage : NSObject <MDMAnimatorStates>
@end

@implementation MDMAnimatorStatesStorage {
  NSMutableDictionary *_states;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _states = [NSMutableDictionary dictionary];
  }
  return self;
}

- (NSDictionary<NSString *, id> *)objectForKeyedSubscript:(NSString *)key {
  NSDictionary *state = _states[key];
  if (!state) {
    state = [NSMutableDictionary dictionary];
    _states[key] = state;
  }
  return state;
}

- (void)setObject:(NSDictionary<NSString *, id> *)obj forKeyedSubscript:(NSString *)key {
  [_states setObject:obj forKey:key];
}

@end

@interface MDMAnimatorOptionsStorage : NSObject <MDMAnimatorOptions>
@end

@implementation MDMAnimatorOptionsStorage {
  NSMutableDictionary *_states;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _states = [NSMutableDictionary dictionary];
  }
  return self;
}

- (id<MDMAnimationConfigurator>)objectForKeyedSubscript:(NSString *)key {
  return _states[key];
}

- (void)setObject:(id<MDMAnimationConfigurator>)obj forKeyedSubscript:(NSString *)key {
  [_states setObject:obj forKey:key];
}

@end

@implementation MDMAnimator {
  __weak id _object;
  MDMAnimatorStatesStorage *_states;
  MDMAnimatorOptionsStorage *_options;

  NSString *_state;
}

- (instancetype)initWithObject:(id)object {
  self = [super init];
  if (self) {
    _object = object;
    _states = [[MDMAnimatorStatesStorage alloc] init];
    _options = [[MDMAnimatorOptionsStorage alloc] init];

    _defaultTiming = (MDMMotionTiming){
      .delay = 0.000,
      .duration = 0.300,
      .curve = _MDMBezier(0.4f, 0.0f, 0.2f, 1.0f)
    };
  }
  return self;
}

- (id<MDMAnimatorStates>)states {
  return _states;
}

- (id<MDMAnimatorOptions>)configurationForState {
  return _options;
}

- (void(^)(id, MDMMotionProperty, id, MDMMotionTiming))propertyAnimatorForProperty:(MDMMotionProperty)prop {
  // TODO(featherless): Allow this to be configured externally so that other animation systems can
  // be used.

  if ([_object isKindOfClass:[CALayer class]]
      || ([self layerFromObject:_object] && [prop isEqualToString:@"cornerRadius"])) {

    return ^(id object, MDMMotionProperty property, id value, MDMMotionTiming timing) {
      CALayer *layer = [self layerFromObject:_object];

      CABasicAnimation *animation;
      switch (timing.curve.type) {
        case MDMMotionCurveTypeInstant:
          animation = nil;
          break;

        case MDMMotionCurveTypeDefault:
        case MDMMotionCurveTypeBezier:
          animation = [CABasicAnimation animationWithKeyPath:property];
          animation.timingFunction = timingFunctionWithControlPoints(timing.curve.data);
          animation.duration = timing.duration * simulatorAnimationDragCoefficient();
          break;

        case MDMMotionCurveTypeSpring: {
          CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:property];
          spring.mass = timing.curve.data[0];
          spring.stiffness = timing.curve.data[1];
          spring.damping = timing.curve.data[2];
          spring.duration = spring.settlingDuration;
          animation = spring;
          break;
        }
      }

      if (animation) {
        if (timing.delay != 0) {
          animation.beginTime = ([layer convertTime:CACurrentMediaTime() fromLayer:nil]
                                 + timing.delay * simulatorAnimationDragCoefficient());
          animation.fillMode = kCAFillModeBackwards;
        }

        // TODO(featherless): Support other numerical types.
        if ([value isKindOfClass:[NSNumber class]]) {
          CGFloat currentValue = [[layer valueForKeyPath:property] doubleValue];
          animation.fromValue = @(currentValue - [value doubleValue]);
          animation.toValue = @0;
          animation.additive = true;

        } else {
          animation.toValue = value;
        }

        NSString *uniqueKey = [animation.keyPath stringByAppendingString:[NSUUID UUID].UUIDString];
        [layer addAnimation:animation forKey:uniqueKey];
      }

      [layer setValue:value forKeyPath:property];
    };

  } else if ([_object isKindOfClass:[UIView class]]) {
    return ^(UIView *view, MDMMotionProperty property, id value, MDMMotionTiming timing) {

      void (^animations)() = ^{
        // TODO: Route key paths somehow.

        if ([property isEqualToString:@"x"]) {
          [view.layer setValue:value forKeyPath:@"position.x"];

        } else if ([property isEqualToString:@"size"]) {
          [view.layer setValue:value forKeyPath:@"bounds.size"];

        } else {
          [view setValue:value forKeyPath:property];
        }
      };

      switch (timing.curve.type) {
        case MDMMotionCurveTypeInstant:
          animations();
          break;

        case MDMMotionCurveTypeDefault:
        case MDMMotionCurveTypeBezier:
          [UIView animateWithDuration:timing.duration
                                delay:timing.delay
                              options:0
                           animations:animations
                           completion:nil];
          break;

        case MDMMotionCurveTypeSpring: {

          // A spring exhibits the following characteristics:
          //
          // critically damped when friction / sqrt(4 * tension) = 1
          //      under damped when friction / sqrt(4 * tension) < 1
          //       over damped when friction / sqrt(4 * tension) > 1
          //
          // iOS' UIView spring API seems to model its damping parameter off of these
          // characteristics, so we'll attempt to calculate a reasonable damping value based on the
          // friction/tension parameters.
          CGFloat friction = timing.curve.data[MDMSpringMotionCurveDataIndexFriction];
          CGFloat tension = timing.curve.data[MDMSpringMotionCurveDataIndexTension];
          CGFloat divisor = sqrt(4 * tension);
          CGFloat damping;
          if (fabs(divisor) > 0.00001) {
            damping = friction / divisor;
          } else {
            damping = 0;
          }

          [UIView animateWithDuration:timing.duration
                                delay:timing.delay
               usingSpringWithDamping:damping
                initialSpringVelocity:0
                              options:0
                           animations:animations
                           completion:nil];
          break;
        }
      }
    };
  }
  return nil;
}

#pragma mark - Animate

- (void)animateToValues:(NSDictionary<NSString *, id> *)values timing:(MDMMotionTiming)timing {
  for (MDMMotionProperty property in values) {
    id value = values[property];

    void (^animator)(id, MDMMotionProperty, id, MDMMotionTiming) = [self propertyAnimatorForProperty:property];
    animator(_object, property, value, timing);
  }
}

- (void)animateToValues:(NSDictionary<NSString *, id> *)values options:(id<MDMAnimationConfigurator>)keyedOptions {
  for (MDMMotionProperty property in values) {
    id value = values[property];

    MDMMotionTiming timing;
    if (keyedOptions) {
      timing = [keyedOptions timingForProperty:property];

      if (timing.duration == MDMMotionTimingDefault.duration) {
        timing = self.defaultTiming;
      }

      // TODO: Check for MDMMotionTimingInstantaneous

    } else {
      timing = self.defaultTiming;
    }

    void (^animator)(id, MDMMotionProperty, id, MDMMotionTiming) = [self propertyAnimatorForProperty:property];
    animator(_object, property, value, timing);
  }
}

- (void)animateToValues:(NSDictionary<NSString *, id> *)values {
  [self animateToValues:values timing:self.defaultTiming];
}

- (void)animateToState:(NSString *)state {
  _state = state;

  [self animateToState:state completion:^(BOOL didComplete) {}];
}

- (void)animateToState:(nonnull NSString *)name completion:(void (^)(BOOL didComplete))completion {
  _state = name;

  [CATransaction begin];
  [CATransaction setCompletionBlock:^{
    completion([_state isEqualToString:name]);
  }];
  NSDictionary *state = self.states[name];
  id<MDMAnimationConfigurator> options = self.configurationForState[name];
  [self animateToValues:state options:options];
  [CATransaction commit];
}

#pragma mark - Private

- (CALayer *)layerFromObject:(id)object {
  CALayer *layer = nil;
  if ([_object isKindOfClass:[UIView class]]) {
    layer = [(UIView *)_object layer];

  } else if ([_object isKindOfClass:[CALayer class]]) {
    layer = _object;
  }
  return layer;
}

@end
