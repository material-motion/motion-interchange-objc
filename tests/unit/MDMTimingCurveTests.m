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

@interface MDMTimingCurveTests : XCTestCase
@end

@implementation MDMTimingCurveTests

- (void)testLinearCurveConstantMatchesSystemLinearCurve {
  MDMTimingCurve curve = MDMTimingCurveLinear;
  CAMediaTimingFunction *linearTimingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  MDMTimingCurve systemLinearCurve = MDMTimingCurveFromTimingFunction(linearTimingFunction);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP1X],
                             systemLinearCurve.data[MDMTimingCurveBezierDataIndexP1X],
                             0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP1Y],
                             systemLinearCurve.data[MDMTimingCurveBezierDataIndexP1Y],
                             0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP2X],
                             systemLinearCurve.data[MDMTimingCurveBezierDataIndexP2X],
                             0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP2Y],
                             systemLinearCurve.data[MDMTimingCurveBezierDataIndexP2Y],
                             0.001);
}

- (void)testBezierCurveData {
  MDMTimingCurve curve = MDMTimingCurveMakeBezier(0.1f, 0.2f, 0.3f, 0.4f);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP1X], 0.1, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP1Y], 0.2, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP2X], 0.3, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveBezierDataIndexP2Y], 0.4, 0.001);
}

- (void)testSpringCurveData {
  MDMTimingCurve curve = MDMTimingCurveMakeSpring(0.1f, 0.2f, 0.3f);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveSpringDataIndexMass], 0.1, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveSpringDataIndexTension], 0.2, 0.001);
  XCTAssertEqualWithAccuracy(curve.data[MDMTimingCurveSpringDataIndexFriction], 0.3, 0.001);
}

@end
