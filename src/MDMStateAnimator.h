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

#if __has_attribute(objc_boxable)
typedef struct __attribute__((objc_boxable)) CGPoint CGPoint;
typedef struct __attribute__((objc_boxable)) CGSize CGSize;
typedef struct __attribute__((objc_boxable)) CGRect CGRect;
typedef struct __attribute__((objc_boxable)) CGVector CGVector;
#endif

/**
 A timing structure that indicates that no animation should occur.
 */
extern const MDMMotionTiming MDMMotionTimingInstantaneous
NS_SWIFT_NAME(MotionTimingInstantaneous);

/**
 A timing structure that indicates that no timing is provided - equivalent to "nil".
 */
extern const MDMMotionTiming MDMMotionTimingNone
NS_SWIFT_NAME(MotionTimingNone);

typedef NSString* MDMMotionProperty;

/**
 An animation configurator is responsible for customizing the timing parameters of an animation
 for a given property.
 */
NS_SWIFT_NAME(AnimationConfigurator)
@protocol MDMAnimationConfigurator

/**
 Asks the receiver to return a timing structure for the given property.
 
 If MDMMotionTimingNone is returned, then default timing will be used.
 */
- (MDMMotionTiming)timingForProperty:(nonnull MDMMotionProperty)property;

@end

/**
 An AnimatorStates instance stores the desired values for an object at a given named state.

 Example usage (Objective-C):
 
     states[@"open"] = @{ @"x": @500 }

 Example usage (Swift):
 
     states["open"] = [ "x": 500 ]
 */
NS_SWIFT_NAME(AnimatorStates)
@protocol MDMAnimatorStates

// Subscript access support
- (nullable NSDictionary<NSString *, id> *)objectForKeyedSubscript:(nonnull NSString *)stateName;
- (void)setObject:(nullable NSDictionary<NSString *, id> *)obj forKeyedSubscript:(nonnull NSString *)stateName;

@end

/**
 An AnimatorOptions instance stores the desired configurations for an object at a given name state.
 */
NS_SWIFT_NAME(AnimatorOptions)
@protocol MDMAnimatorOptions

// Subscript access support
- (nullable id<MDMAnimationConfigurator>)objectForKeyedSubscript:(nonnull NSString *)stateName;
- (void)setObject:(nullable id<MDMAnimationConfigurator>)obj forKeyedSubscript:(nonnull NSString *)stateName;

@end

@interface MDMAnimator : NSObject

- (nonnull instancetype)initWithObject:(nonnull id)object NS_DESIGNATED_INITIALIZER;

@property(nonatomic, strong, readonly, nonnull) id<MDMAnimatorStates> states;

@property(nonatomic, strong, readonly, nonnull) id<MDMAnimatorOptions> configurationForState;

- (void)animateToValues:(nonnull NSDictionary<NSString *, id> *)values;

// TODO: Do we like this?
- (void)animateToValues:(nonnull NSDictionary<NSString *, id> *)values timing:(MDMMotionTiming)timing;

- (void)animateToState:(nonnull NSString *)state;

- (nonnull instancetype)init NS_UNAVAILABLE;;

@end

@interface UIView (MaterialMotion)

@property(nonatomic, strong, readonly, nonnull) MDMAnimator *mdm_animator NS_SWIFT_NAME(animator);

@end
