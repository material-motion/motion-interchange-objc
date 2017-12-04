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

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/**
 The possible kinds of traits curves that can be used to describe an animation.
 */
typedef NS_ENUM(NSUInteger, MDMTimingCurveType) {
  /**
   The value will be instantly set with no animation.
   */
  MDMTimingCurveTypeInstant = 0,

  /**
   The value will be animated using a cubic bezier curve to model its velocity.

   The associated data values are interpreted as follows:

   data[0] = p1.x
   data[1] = p1.y
   data[2] = p2.x
   data[3] = p2.y

   as part of a four point cubic bezier where the first point is (0, 0) and the last is (1, 1):
   [(0, 0), p1, p2, (1, 1)]
   */
  MDMTimingCurveTypeBezier = 1,

  /**
   The value will be animated using a spring simulation.

   A spring will treat the duration property of the traits as a suggestion and may choose to
   ignore it altogether.

   The associated data values are interpreted as follows:

   data[0] = mass
   data[1] = tension
   data[2] = friction
   data[3] = initial velocity
   */
  MDMTimingCurveTypeSpring = 2,

} NS_SWIFT_NAME(TimingCurveType);

/**
 A generalized representation of a traits curve.
 */
typedef struct MDMTimingCurve {
  /**
   The type defines how to interpret the data values.
   */
  MDMTimingCurveType type;

  /**
   The data values corresponding with this curve.
   */
  CGFloat data[4];
} NS_SWIFT_NAME(TimingCurve) MDMTimingCurve;

/**
 Creates a bezier traits curve with the provided control points.

 A cubic bezier has four control points in total. We assume that the first control point (p0) is
 0, 0 and the last control point (p3) is 1, 1. This method requires that you provide the second (p1)
 and third (p2) control points, resulting in the following cubic bezier points:
 `[(0, 0), p1, p2, (1, 1)]`.

 See the documentation for CAMediaTimingFunction for more information.
 */
// clang-format off
FOUNDATION_EXTERN
MDMTimingCurve MDMTimingCurveMakeBezier(CGFloat p1x, CGFloat p1y, CGFloat p2x, CGFloat p2y)
    NS_SWIFT_NAME(TimingCurve(bezierWithP1x:p1y:p2x:p2y:));
// clang-format on

// clang-format off
FOUNDATION_EXTERN
MDMTimingCurve MDMTimingCurveFromTimingFunction(CAMediaTimingFunction * _Nonnull traitsFunction)
    NS_SWIFT_NAME(TimingCurve(fromTimingFunction:));
// clang-format on

/**
 Creates a spring curve with the provided configuration.

 Tension and friction map to Core Animation's stiffness and damping, respectively.

 See the documentation for CASpringAnimation for more information.
 */
// clang-format off
FOUNDATION_EXTERN
MDMTimingCurve MDMTimingCurveMakeSpring(CGFloat mass, CGFloat tension, CGFloat friction)
    NS_SWIFT_NAME(TimingCurve(springWithMass:tension:friction:));
// clang-format on

/**
 Creates a spring curve with the provided configuration.

 Tension and friction map to Core Animation's stiffness and damping, respectively.

 See the documentation for CASpringAnimation for more information.
 */
// clang-format off
FOUNDATION_EXTERN
MDMTimingCurve MDMTimingCurveMakeSpringWithInitialVelocity(CGFloat mass,
                                                           CGFloat tension,
                                                           CGFloat friction,
                                                           CGFloat initialVelocity)
    NS_SWIFT_NAME(TimingCurve(springWithMass:tension:friction:initialVelocity:));
// clang-format on

/**
 For cubic bezier curves, returns a reversed cubic bezier curve. For all other curve types, a copy
 of the original curve is returned.
 */
// clang-format off
FOUNDATION_EXTERN MDMTimingCurve MDMTimingCurveReversedBezier(MDMTimingCurve traitsCurve)
    NS_SWIFT_NAME(TimingCurve(reversedFromTimingCurve:));
// clang-format on

/**
 Named indices for the bezier traits curve's data array.
 */
typedef NS_ENUM(NSUInteger, MDMTimingCurveBezierDataIndex) {
  MDMTimingCurveBezierDataIndexP1X = 0,
  MDMTimingCurveBezierDataIndexP1Y = 1,
  MDMTimingCurveBezierDataIndexP2X = 2,
  MDMTimingCurveBezierDataIndexP2Y = 3
} NS_SWIFT_NAME(TimingCurveBezierDataIndex);

/**
 Named indices for the spring traits curve's data array.
 */
typedef NS_ENUM(NSUInteger, MDMTimingCurveSpringDataIndex) {
  MDMTimingCurveSpringDataIndexMass = 0,
  MDMTimingCurveSpringDataIndexTension = 1,
  MDMTimingCurveSpringDataIndexFriction = 2,

  /**
   The initial velocity of the animation.

   A value of zero indicates no initial velocity.
   A positive value indicates movement toward the destination.
   A negative value indicates movement away from the destination.

   The value's units are dependent on the context and the value being animated.
   */
  MDMTimingCurveSpringDataIndexInitialVelocity
} NS_SWIFT_NAME(TimingCurveSpringDataIndex);

/**
 A linear bezier traits curve.
 */
FOUNDATION_EXPORT const MDMTimingCurve MDMTimingCurveLinear;
