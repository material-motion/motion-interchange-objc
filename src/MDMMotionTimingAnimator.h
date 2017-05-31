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

#import <Foundation/Foundation.h>

#import "MDMMotionTiming.h"

/**
 A motion timing animator is responsible for adding Core Animation animations to a layer based on a
 provided timing structure.
 */
NS_SWIFT_NAME(MotionTimingAnimator)
@interface MDMMotionTimingAnimator : NSObject

/**
 Adds a single animation to the layer with the given timing structure.
 
 If the animation is delayed, the added animation will have a backwards fill mode.

 The animation will be added to the layer with `keyPath` as the key.

 Side effects:

 - Sets the last value of the animation to the layer's key path.

 @param timing The timing to be used for the animation.
 @param layer The layer to be animated.
 @param values The values to be used in the animation. Must contain exactly two values. Supported
 UIKit types will be coerced to their Core Animation equivalent. Supported UIKit values include
 UIColor and UIBezierPath.
 @param keyPath The key path of the property to be animated.
 */
- (void)addAnimationWithTiming:(MDMMotionTiming)timing
                       toLayer:(nonnull CALayer *)layer
                    withValues:(nonnull NSArray *)values
                       keyPath:(nonnull NSString *)keyPath;

/**
 If enabled, all animations will reverse the provided values array before building the animation.
 
 The default value is false.
 */
@property(nonatomic, assign) BOOL shouldReverseValues;

@end
