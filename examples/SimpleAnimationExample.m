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

#import "SimpleAnimationExample.h"

#import <MotionInterchange/MotionInterchange.h>

#import "MotionInterchangeCatalog-Swift.h"

#define easeInEaseOut {0.4f, 0.0f, 0.2f, 1.0f}

struct MaterialMaskedTransitionMotion {
  MDMMotionTiming floodColorTransformation;
  MDMMotionTiming maskTransformation;
  BOOL isCentered;
};
typedef struct MaterialMaskedTransitionMotion MaterialMaskedTransitionMotion;

static const MaterialMaskedTransitionMotion cardExpansion = {
  .floodColorTransformation = {
    .delay = 0.075, .duration = 0.075, .controlPoints = easeInEaseOut,
  },
  .maskTransformation = {
    .delay = 0.045, .duration = 0.255, .controlPoints = easeInEaseOut,
  }
};

static const MaterialMaskedTransitionMotion cardCollapse = {
  .floodColorTransformation = {
    .delay = 0.060, .duration = 0.150, .controlPoints = easeInEaseOut,
  },
  .maskTransformation = {
    .delay = 0.000, .duration = 0.180, .controlPoints = easeInEaseOut,
  }
};

@interface MaterialMaskedTransitionConfigurator : NSObject <MDMAnimationConfigurator>
@end

@implementation MaterialMaskedTransitionConfigurator {
  MaterialMaskedTransitionMotion _spec;
}

- (instancetype)initWithSpec:(MaterialMaskedTransitionMotion)spec {
  self = [super init];
  if (self) {
    _spec = spec;
  }
  return self;
}

- (MDMMotionTiming)timingForProperty:(MDMMotionProperty)key {
  if ([key isEqualToString:@"backgroundColor"]) {
    return _spec.floodColorTransformation;

  } else if ([[NSSet setWithObjects:@"position", @"cornerRadius", @"size", nil] containsObject:key]) {
    return _spec.maskTransformation;
  }

  return MDMMotionTimingNone;
}

@end

@implementation SimpleAnimationExampleObjcViewController {
  UIButton *_button;
  BOOL _isOpen;
}

- (void)didTap {
  _isOpen = !_isOpen;

  [_button.mdm_animator animateToState: _isOpen ? @"open" : @"closed"];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor backgroundColor];

  _button = [UIButton buttonWithType:UIButtonTypeCustom];
  _button.backgroundColor = [UIColor primaryColor];
  _button.bounds = CGRectMake(0, 0, 64, 64);
  _button.center = CGPointMake(self.view.bounds.size.width / 2,
                               self.view.bounds.size.height - _button.bounds.size.height - 32);
  _button.layer.cornerRadius = _button.bounds.size.width / 2;
  [self.view addSubview:_button];

  MDMAnimator *animator = _button.mdm_animator;

  animator.states[@"closed"] =
  @{@"backgroundColor": [UIColor primaryColor],
    @"cornerRadius": @(_button.layer.cornerRadius),
    @"size": @(_button.bounds.size),
    @"position": @(_button.layer.position)};

  animator.states[@"open"] =
  @{@"backgroundColor": [UIColor secondaryColor],
    @"cornerRadius": @0,
    @"size": @(CGSizeMake(128, 128)),
    @"position": @(CGPointMake(_button.layer.position.x, _button.layer.position.y - 64))};

  animator.configurationForState[@"open"] = [[MaterialMaskedTransitionConfigurator alloc] initWithSpec:cardExpansion];
  animator.configurationForState[@"closed"] = [[MaterialMaskedTransitionConfigurator alloc] initWithSpec:cardCollapse];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
  [tap addTarget:self action:@selector(didTap)];
  [self.view addGestureRecognizer:tap];
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"1. Simple animation (objc)" ];
}

@end
