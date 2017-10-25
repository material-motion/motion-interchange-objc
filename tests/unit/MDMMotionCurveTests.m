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

#import <XCTest/XCTest.h>

#import "MotionInterchange.h"

@interface MDMMotionCurveTests : XCTestCase
@end

@implementation MDMMotionCurveTests

- (void)testBezierCurveData {
  MDMMotionCurve curve = MDMMotionCurveMakeBezier(0.1f, 0.2f, 0.3f, 0.4f);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP1X], 0.1, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP1Y], 0.2, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP2X], 0.3, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP2Y], 0.4, 0.001);
}

- (void)testSpringCurveData {
  MDMMotionCurve curve = MDMMotionCurveMakeSpring(0.1f, 0.2f, 0.3f);
  XCTAssertEqualWithAccuracy(curve.data[MDMSpringMotionCurveDataIndexMass], 0.1, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMSpringMotionCurveDataIndexTension], 0.2, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMSpringMotionCurveDataIndexFriction], 0.3, 0.001);
}

- (void)testBezierCurveDataWithMacro {
  MDMMotionCurve curve = _MDMBezier(0.1, 0.2, 0.3, 0.4);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP1X], 0.1, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP1Y], 0.2, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP2X], 0.3, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMBezierMotionCurveDataIndexP2Y], 0.4, 0.001);
}

- (void)testSpringCurveDataWithMacro {
  MDMMotionCurve curve = _MDMSpring(0.1, 0.2, 0.3);
  XCTAssertEqualWithAccuracy(curve.data[MDMSpringMotionCurveDataIndexMass], 0.1, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMSpringMotionCurveDataIndexTension], 0.2, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMSpringMotionCurveDataIndexFriction], 0.3, 0.001);
}

- (void)testSystemModalMovementTimingCurveMatchesModalMovementTiming {
  UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  window.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  [window makeKeyAndVisible];

  UIViewController *presentedViewController = [[UIViewController alloc] initWithNibName:nil
                                                                                 bundle:nil];
  XCTestExpectation *didComplete =
      [[XCTestExpectation alloc] initWithDescription:@"Animation completed."];
  [window.rootViewController presentViewController:presentedViewController
                                          animated:YES
                                        completion:^{
                                          [didComplete fulfill];
                                        }];

  XCTestExpectation *didExtractAnimationValues =
      [[XCTestExpectation alloc] initWithDescription:@"Extracted animation values."];
  dispatch_async(dispatch_get_main_queue(), ^{
    CAAnimation *animation = [presentedViewController.view.layer animationForKey:@"position"];
    XCTAssertTrue([animation isKindOfClass:[CASpringAnimation class]]);
    CASpringAnimation *springAnimation = (CASpringAnimation *)animation;

    MDMMotionTiming timing = MDMModalMovementTiming;
    XCTAssertEqualWithAccuracy(timing.curve.data[MDMSpringMotionCurveDataIndexMass],
                               springAnimation.mass,
                               0.001);
    XCTAssertEqualWithAccuracy(timing.curve.data[MDMSpringMotionCurveDataIndexTension],
                               springAnimation.stiffness,
                               0.001);
    XCTAssertEqualWithAccuracy(timing.curve.data[MDMSpringMotionCurveDataIndexFriction]
                               , springAnimation.damping,
                               0.001);

    [didExtractAnimationValues fulfill];
  });

  XCTWaiterResult result = [XCTWaiter waitForExpectations:@[didComplete, didExtractAnimationValues]
                                                  timeout:1];
  XCTAssertEqual(result, XCTWaiterResultCompleted);
}

@end
