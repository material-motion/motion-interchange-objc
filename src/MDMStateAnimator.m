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

#import "MDMStateAnimator.h"

#import <objc/runtime.h>

const MDMMotionTiming MDMMotionTimingInstantaneous = {
  .duration = -2,
  .delay = 0,
  .controlPoints = {0.0f, 0.0f, 1.0f, 1.0f}
};

const MDMMotionTiming MDMMotionTimingNone = {
  .duration = -1,
  .delay = 0,
  .controlPoints = {0.0f, 0.0f, 1.0f, 1.0f}
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

static CAMediaTimingFunction* timingFunctionWithControlPoints(float controlPoints[4]) {
  return [CAMediaTimingFunction functionWithControlPoints:controlPoints[0]
                                                         :controlPoints[1]
                                                         :controlPoints[2]
                                                         :controlPoints[3]];
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

@interface MDMAnimatorStateOptionsStorage : NSObject <MDMAnimatorStateOptions>
@end

@implementation MDMAnimatorStateOptionsStorage {
  NSMutableDictionary *_states;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _states = [NSMutableDictionary dictionary];
  }
  return self;
}

- (id<MDMAnimatorKeyOptions>)objectForKeyedSubscript:(NSString *)key {
  return _states[key];
}

- (void)setObject:(id<MDMAnimatorKeyOptions>)obj forKeyedSubscript:(NSString *)key {
  [_states setObject:obj forKey:key];
}

@end

const MDMMotionTiming defaultTiming = {.delay = 0.000, .duration = 0.300, .controlPoints = {0.4f, 0.0f, 0.2f, 1.0f}};

@implementation UIView (MaterialMotion)

- (id<MDMAnimatorStates>)states {
  id<MDMAnimatorStates> states = objc_getAssociatedObject(self, _cmd);
  if (!states) {
    states = [[MDMAnimatorStatesStorage alloc] init];
    objc_setAssociatedObject(self, _cmd, states, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return states;
}

- (id<MDMAnimatorStateOptions>)optionsForState {
  id<MDMAnimatorStateOptions> states = objc_getAssociatedObject(self, _cmd);
  if (!states) {
    states = [[MDMAnimatorStateOptionsStorage alloc] init];
    objc_setAssociatedObject(self, _cmd, states, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return states;
}

- (void)animateToValues:(NSDictionary<NSString *, id> *)values timing:(MDMMotionTiming)timing {
  [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
    for (NSString *keyPath in values) {
      id value = values[keyPath];

      if ([keyPath isEqualToString:@"x"]) {
        [self.layer setValue:value forKeyPath:@"position.x"];

      } else {
        [self setValue:value forKeyPath:keyPath];
      }
    }

  } completion: nil];
}

- (void)animateToValues:(NSDictionary<NSString *, id> *)values options:(id<MDMAnimatorKeyOptions>)keyedOptions {

  for (NSString *key in values) {
    id value = values[key];
    MDMMotionTiming timing;
    if (keyedOptions) {
      timing = [keyedOptions timingForKey:key];

      if (timing.duration == MDMMotionTimingNone.duration) {
        timing = defaultTiming;
      }

      // TODO: Check for MDMMotionTimingInstantaneous

    } else {
      timing = defaultTiming;
    }

    if ([key isEqualToString:@"cornerRadius"]) {
      CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
      if (timing.delay != 0) {
        animation.beginTime = ([self.layer convertTime:CACurrentMediaTime() fromLayer:nil]
                               + timing.delay * simulatorAnimationDragCoefficient());
        animation.fillMode = kCAFillModeBackwards;
      }
      animation.duration = timing.duration * simulatorAnimationDragCoefficient();
      animation.timingFunction = timingFunctionWithControlPoints(timing.controlPoints);

      // TODO: Support other numerical types.
      CGFloat currentValue = [[self.layer valueForKeyPath:key] doubleValue];
      animation.fromValue = @(currentValue - [value doubleValue]);
      animation.toValue = @0;
      animation.additive = true;

      NSString *uniqueKey = [animation.keyPath stringByAppendingString:[NSUUID UUID].UUIDString];
      [self.layer addAnimation:animation forKey:uniqueKey];

      [self.layer setValue:value forKeyPath:animation.keyPath];

    } else {
      [UIView animateWithDuration:timing.duration delay:timing.delay options:0 animations:^{

        // TODO: Extract this out to a keypath router.
        if ([key isEqualToString:@"x"]) {
          [self.layer setValue:value forKeyPath:@"position.x"];

        } else if ([key isEqualToString:@"size"]) {
          [self.layer setValue:value forKeyPath:@"bounds.size"];

        } else {
          [self setValue:value forKeyPath:key];
        }
      } completion: nil];
    }
  }
}

- (void)animateToValues:(NSDictionary<NSString *, id> *)values {
  [self animateToValues:values timing:defaultTiming];
}

- (void)animateToState:(NSString *)name {
  NSDictionary *state = self.states[name];
  id<MDMAnimatorKeyOptions> options = self.optionsForState[name];
  [self animateToValues:state options:options];
}

@end
