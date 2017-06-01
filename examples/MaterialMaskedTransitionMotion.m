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

#import "MaterialMaskedTransitionMotion.h"

#define easeInEaseOut {0.4f, 0.0f, 0.2f, 1.0f}

const MaterialMaskedTransitionMotion cardExpansion = {
  .floodColorTransformation = {
    .delay = 0.075, .duration = 0.075, .controlPoints = easeInEaseOut,
  },
  .maskTransformation = {
    .delay = 0.045, .duration = 0.255, .controlPoints = easeInEaseOut,
  }
};

const MaterialMaskedTransitionMotion cardCollapse = {
  .floodColorTransformation = {
    .delay = 0.060, .duration = 0.150, .controlPoints = easeInEaseOut,
  },
  .maskTransformation = {
    .delay = 0.000, .duration = 0.180, .controlPoints = easeInEaseOut,
  }
};

@implementation MaterialMaskedTransitionConfigurator {
  MaterialMaskedTransitionMotion _spec;

  NSSet *_maskTransformationProperties;
}

- (instancetype)initWithSpec:(MaterialMaskedTransitionMotion)spec {
  self = [super init];
  if (self) {
    _spec = spec;

    _maskTransformationProperties = [NSSet setWithArray:@[@"position", @"cornerRadius", @"size"]];
  }
  return self;
}

- (MDMMotionTiming)timingForProperty:(MDMMotionProperty)key {
  if ([key isEqualToString:@"backgroundColor"]) {
    return _spec.floodColorTransformation;

  } else if ([_maskTransformationProperties containsObject:key]) {
    return _spec.maskTransformation;
  }

  return MDMMotionTimingNone;
}

@end
