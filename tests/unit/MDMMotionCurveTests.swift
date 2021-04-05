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

import XCTest
import MotionInterchange

class MDMMotionCurveTests: XCTestCase {

  func testBezierCurveData() {
    let curve = MotionCurveMakeBezier(p1x: 0.1, p1y: 0.2, p2x: 0.3, p2y: 0.4)
    XCTAssertEqual(curve.data.0, 0.1, accuracy: 0.001)
    XCTAssertEqual(curve.data.1, 0.2, accuracy: 0.001)
    XCTAssertEqual(curve.data.2, 0.3, accuracy: 0.001)
    XCTAssertEqual(curve.data.3, 0.4, accuracy: 0.001)
  }

  func testBezierCurveFromTimingFunction() {
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.1, 0.2, 0.3, 0.4)
    let curve = MotionCurve(fromTimingFunction: timingFunction)
    XCTAssertEqual(curve.data.0, 0.1, accuracy: 0.001)
    XCTAssertEqual(curve.data.1, 0.2, accuracy: 0.001)
    XCTAssertEqual(curve.data.2, 0.3, accuracy: 0.001)
    XCTAssertEqual(curve.data.3, 0.4, accuracy: 0.001)
  }

  func testSpringCurveData() {
    let curve = MotionCurveMakeSpring(mass: 0.1, tension: 0.2, friction: 0.3)
    XCTAssertEqual(curve.data.0, 0.1, accuracy: 0.001) // mass
    XCTAssertEqual(curve.data.1, 0.2, accuracy: 0.001) // tension
    XCTAssertEqual(curve.data.2, 0.3, accuracy: 0.001) // friction
    XCTAssertEqual(curve.data.3, 0.0, accuracy: 0.001)
  }

  func testReversedBezierCurve() {
    let curve = MotionCurveMakeBezier(p1x: 0.1, p1y: 0.2, p2x: 0.3, p2y: 0.4)
    let reversed = MotionCurveReversedBezier(fromMotionCurve: curve)
    XCTAssertEqual(curve.data.0, 1 - reversed.data.2, accuracy: 0.001)
    XCTAssertEqual(curve.data.1, 1 - reversed.data.3, accuracy: 0.001)
    XCTAssertEqual(curve.data.2, 1 - reversed.data.0, accuracy: 0.001)
    XCTAssertEqual(curve.data.3, 1 - reversed.data.1, accuracy: 0.001)
  }

  func testReversingBezierCurveTwiceGivesSameResult() {
    let curve = MotionCurveMakeBezier(p1x: 0.1, p1y: 0.2, p2x: 0.3, p2y: 0.4)
    let reversed = MotionCurveReversedBezier(fromMotionCurve: curve)
    let reversedAgain = MotionCurveReversedBezier(fromMotionCurve: reversed)
    XCTAssertEqual(curve.data.0, reversedAgain.data.0, accuracy: 0.001)
    XCTAssertEqual(curve.data.1, reversedAgain.data.1, accuracy: 0.001)
    XCTAssertEqual(curve.data.2, reversedAgain.data.2, accuracy: 0.001)
    XCTAssertEqual(curve.data.3, reversedAgain.data.3, accuracy: 0.001)
  }
}
