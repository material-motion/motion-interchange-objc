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

class MDMTimingCurveTests: XCTestCase {

  func testInitializerValuesWithNoInitialVelocity() {
    let curve = MDMSpringTimingCurve(mass: 0.1, tension: 0.2, friction: 0.3)
    XCTAssertEqualWithAccuracy(curve.mass, 0.1, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.tension, 0.2, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.friction, 0.3, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.initialVelocity, 0.0, accuracy: 0.001)
  }

  func testInitializerValuesWithInitialVelocity() {
    let curve = MDMSpringTimingCurve(mass: 0.1, tension: 0.2, friction: 0.3, initialVelocity: 0.4)
    XCTAssertEqualWithAccuracy(curve.mass, 0.1, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.tension, 0.2, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.friction, 0.3, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.initialVelocity, 0.4, accuracy: 0.001)
  }
}
