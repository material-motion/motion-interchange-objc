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

class MDMLegacyAPITests: XCTestCase {

  func testTimingValuesMatchTraitValues() {
    let timing = MotionTiming(delay: 0.1,
                                   duration: 0.2,
                                   curve: MotionCurveMakeBezier(p1x: 0.3, p1y: 0.4, p2x: 0.5, p2y: 0.6),
                                   repetition: .init(type: .duration, amount: 0.7, autoreverses: true))

    let traits = MDMAnimationTraits(motionTiming: timing)

    XCTAssertEqualWithAccuracy(traits.duration, timing.duration, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, timing.delay, accuracy: 0.001)
    XCTAssertTrue(traits.timingCurve is CAMediaTimingFunction)
    if let timingCurve = traits.timingCurve as? CAMediaTimingFunction {
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.x, timing.curve.data.0, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.y, timing.curve.data.1, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.x, timing.curve.data.2, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.y, timing.curve.data.3, accuracy: 0.001)
    }
    XCTAssertTrue(traits.repetition is MDMRepetitionOverTime)
    if let repetition = traits.repetition as? MDMRepetitionOverTime {
      XCTAssertEqualWithAccuracy(repetition.duration, timing.repetition.amount, accuracy: 0.001)
      XCTAssertEqual(repetition.autoreverses, timing.repetition.autoreverses.boolValue)
    }
  }

}

