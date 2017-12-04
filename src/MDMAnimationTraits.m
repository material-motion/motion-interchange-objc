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

#import "MDMAnimationTraits.h"

#import "CAMediaTimingFunction+MDMTimingCurve.h"
#import "MDMSpringTimingCurve.h"

@implementation MDMAnimationTraits

- (instancetype)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (nonnull instancetype)initWithDuration:(NSTimeInterval)duration {
  return [self initWithDelay:0 duration:duration];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay duration:(NSTimeInterval)duration {
  return [self initWithDelay:delay
                    duration:duration
          timingFunctionName:kCAMediaTimingFunctionEaseInEaseOut];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay
                     duration:(NSTimeInterval)duration
           timingFunctionName:(NSString *)timingFunctionName {
  CAMediaTimingFunction *timingCurve = [CAMediaTimingFunction functionWithName:timingFunctionName];
  return [self initWithDelay:delay duration:duration timingCurve:timingCurve];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay
                     duration:(NSTimeInterval)duration
                  timingCurve:(id<MDMTimingCurve>)timingCurve {
  return [self initWithDelay:delay duration:duration timingCurve:timingCurve repetition:nil];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay
                     duration:(NSTimeInterval)duration
                  timingCurve:(id<MDMTimingCurve>)timingCurve
                   repetition:(id<MDMRepetitionTraits>)repetition {
  self = [super init];
  if (self) {
    _duration = duration;
    _delay = delay;
    _timingCurve = timingCurve;
    _repetition = repetition;
  }
  return self;
}

@end

@implementation MDMAnimationTraits (SystemTraits)

+ (MDMAnimationTraits *)systemModalMovement {
  MDMSpringTimingCurve *timingCurve = [[MDMSpringTimingCurve alloc] initWithMass:3
                                                                         tension:1000
                                                                        friction:500];
  return [[MDMAnimationTraits alloc] initWithDelay:0 duration:0.500 timingCurve:timingCurve];
}

@end

