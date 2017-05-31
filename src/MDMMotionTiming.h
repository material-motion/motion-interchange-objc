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

/**
 A representation of timing for a simple tween animation.
 */
struct MDMMotionTiming {
  /**
   The amount of time, in seconds, before this animation's value interpolation should begin.
   */
  CFTimeInterval delay;

  /**
   The amount of time, in seconds, over which this animation should interpolate between its values.
   */
  CFTimeInterval duration;

  /**
   The second and third control points of a standard cubic bezier curve.

   See the documentation for CAMediaTimingFunction for more information.

   The values in the array correspond to [c1x, c1y, c2x, c2y].
   */
  float controlPoints[4];
} NS_SWIFT_NAME(MotionTiming);
typedef struct MDMMotionTiming MDMMotionTiming;

// A timing structure that has no duration.
//
// Represents an absence of animation.
#define MDMNoAnimation (MDMMotionTiming){ .duration = 0 }
