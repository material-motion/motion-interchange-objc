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

@protocol MDMAnimatorStates

- (nullable NSDictionary<NSString *, id> *)objectForKeyedSubscript:(nonnull NSString *)key;
- (void)setObject:(nullable NSDictionary<NSString *, id> *)obj forKeyedSubscript:(nonnull NSString *)key;

@end

@protocol MDMAnimatorKeyOptions

- (MDMMotionTiming)timingForKey:(nonnull NSString *)key;

@end

@protocol MDMAnimatorStateOptions

- (nullable id<MDMAnimatorKeyOptions>)objectForKeyedSubscript:(nonnull NSString *)key;
- (void)setObject:(nullable id<MDMAnimatorKeyOptions>)obj forKeyedSubscript:(nonnull NSString *)key;

@end

@interface UIView (MaterialMotion)

@property(nonatomic, strong, readonly, nonnull) id<MDMAnimatorStates> states;

@property(nonatomic, strong, readonly, nonnull) id<MDMAnimatorStateOptions> optionsForState;

- (void)animateToValues:(nonnull NSDictionary<NSString *, id> *)values;

// TODO: Do we like this?
- (void)animateToValues:(nonnull NSDictionary<NSString *, id> *)values timing:(MDMMotionTiming)timing;

- (void)animateToState:(nonnull NSString *)state;

@end
