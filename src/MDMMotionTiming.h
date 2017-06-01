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

typedef NS_ENUM(NSUInteger, MDMMotionCurveType) {
  MDMMotionCurveTypeDefault,
  MDMMotionCurveTypeBezier,
  MDMMotionCurveTypeSpring,
  MDMMotionCurveTypeInstant,
} NS_SWIFT_NAME(MotionCurveType);

struct MDMMotionCurve {
  MDMMotionCurveType type;
  CGFloat data[4];
} NS_SWIFT_NAME(MotionCurve);
typedef struct MDMMotionCurve MDMMotionCurve;

typedef NS_ENUM(NSUInteger, MDMBezierMotionCurveDataIndex) {
  MDMSpringMotionCurveDataIndexP1X,
  MDMSpringMotionCurveDataIndexP1Y,
  MDMSpringMotionCurveDataIndexP2X,
  MDMSpringMotionCurveDataIndexP2Y
} NS_SWIFT_NAME(BezierMotionCurveDataIndex);

typedef NS_ENUM(NSUInteger, MDMSpringMotionCurveDataIndex) {
  MDMSpringMotionCurveDataIndexMass,
  MDMSpringMotionCurveDataIndexTension,
  MDMSpringMotionCurveDataIndexFriction
} NS_SWIFT_NAME(SpringMotionCurveDataIndex);

/**
 The second and third control points of a standard cubic bezier curve.

 See the documentation for CAMediaTimingFunction for more information.

 The values in the array correspond to [c1x, c1y, c2x, c2y].
 */
FOUNDATION_EXTERN MDMMotionCurve MDMMotionCurveMakeBezier(float p1x, float p1y, float p2x, float p2y)
NS_SWIFT_NAME(MotionCurveMakeBezier(p1x:p1y:p2x:p2y:));

FOUNDATION_EXTERN MDMMotionCurve MDMMotionCurveMakeSpring(float mass, float tension, float friction)
NS_SWIFT_NAME(MotionCurveMakeSpring(mass:tension:friction:));

#define _MDMBezier(p1x, p1y, p2x, p2y) (MDMMotionCurve){ \
  .type = MDMMotionCurveTypeBezier, \
  .data = {p1x, p1y, p2x, p2y} \
}

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

  MDMMotionCurve curve;
} NS_SWIFT_NAME(MotionTiming);
typedef struct MDMMotionTiming MDMMotionTiming;
