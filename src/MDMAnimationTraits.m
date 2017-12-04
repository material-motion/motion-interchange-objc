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
  return [self initWithDuration:duration delay:0];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
  CAMediaTimingFunction *easeInOut =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  return [self initWithDuration:duration delay:delay timingCurve:easeInOut];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                           delay:(NSTimeInterval)delay
                     timingCurve:(id<MDMTimingCurve>)timingCurve {
  return [self initWithDuration:duration delay:delay timingCurve:timingCurve repetition:nil];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                           delay:(NSTimeInterval)delay
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
  return [[MDMAnimationTraits alloc] initWithDuration:0.500 delay:0 timingCurve:timingCurve];
}

@end

