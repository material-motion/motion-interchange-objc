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

class CAMediaTimingFunctionTests: XCTestCase {
  func testReversalAlgorithm() {
    let curve = CAMediaTimingFunction(controlPoints: 0.1, 0.2, 0.3, 0.4)
    let reversed = curve.mdm_reversed()
    XCTAssertEqualWithAccuracy(curve.mdm_point1.x, 1 - reversed.mdm_point2.x, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.mdm_point1.y, 1 - reversed.mdm_point2.y, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.mdm_point2.x, 1 - reversed.mdm_point1.x, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.mdm_point2.y, 1 - reversed.mdm_point1.y, accuracy: 0.001)
  }

  func testReversingBezierCurveTwiceGivesSameResult() {
    let curve = CAMediaTimingFunction(controlPoints: 0.1, 0.2, 0.3, 0.4)
    let reversed = curve.mdm_reversed()
    let reversedAgain = reversed.mdm_reversed()
    XCTAssertEqualWithAccuracy(curve.mdm_point1.x, reversedAgain.mdm_point1.x, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.mdm_point1.y, reversedAgain.mdm_point1.y, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.mdm_point2.x, reversedAgain.mdm_point2.x, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.mdm_point2.y, reversedAgain.mdm_point2.y, accuracy: 0.001)
  }
}
