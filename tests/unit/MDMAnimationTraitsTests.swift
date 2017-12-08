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

class MDMAnimationTraitsTests: XCTestCase {

  func testInitializerValuesWithDuration() {
    let traits = MDMAnimationTraits(duration: 0.5)

    XCTAssertEqualWithAccuracy(traits.duration, 0.5, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, 0, accuracy: 0.001)
    XCTAssertTrue(traits.timingCurve is CAMediaTimingFunction)
    if let timingCurve = traits.timingCurve as? CAMediaTimingFunction {
      let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.x, easeInOut.mdm_point1.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.y, easeInOut.mdm_point1.y, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.x, easeInOut.mdm_point2.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.y, easeInOut.mdm_point2.y, accuracy: 0.001)
    }
    XCTAssertNil(traits.repetition)
  }

  func testInitializerValuesWithDurationAndEaseInCurve() {
    let traits = MDMAnimationTraits(duration: 0.5, animationCurve: .easeIn)

    XCTAssertEqualWithAccuracy(traits.duration, 0.5, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, 0, accuracy: 0.001)
    XCTAssertTrue(traits.timingCurve is CAMediaTimingFunction)
    if let timingCurve = traits.timingCurve as? CAMediaTimingFunction {
      let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.x, easeInOut.mdm_point1.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.y, easeInOut.mdm_point1.y, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.x, easeInOut.mdm_point2.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.y, easeInOut.mdm_point2.y, accuracy: 0.001)
    }
    XCTAssertNil(traits.repetition)
  }

  func testInitializerValuesWithDurationDelay() {
    let traits = MDMAnimationTraits(delay: 0.2, duration: 0.5)

    XCTAssertEqualWithAccuracy(traits.duration, 0.5, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, 0.2, accuracy: 0.001)
    XCTAssertTrue(traits.timingCurve is CAMediaTimingFunction)
    if let timingCurve = traits.timingCurve as? CAMediaTimingFunction {
      let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.x, easeInOut.mdm_point1.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.y, easeInOut.mdm_point1.y, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.x, easeInOut.mdm_point2.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.y, easeInOut.mdm_point2.y, accuracy: 0.001)
    }
    XCTAssertNil(traits.repetition)
  }

  func testInitializerValuesWithDurationDelayNilTimingCurve() {
    let traits = MDMAnimationTraits(delay: 0.2, duration: 0.5, timingCurve: nil)

    XCTAssertEqualWithAccuracy(traits.duration, 0.5, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, 0.2, accuracy: 0.001)
    XCTAssertNil(traits.timingCurve)
    XCTAssertNil(traits.repetition)
  }

  func testInitializerValuesWithDurationDelayLinearTimingCurve() {
    let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let traits = MDMAnimationTraits(delay: 0.2, duration: 0.5, timingCurve: linear)

    XCTAssertEqualWithAccuracy(traits.duration, 0.5, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, 0.2, accuracy: 0.001)
    XCTAssertTrue(traits.timingCurve is CAMediaTimingFunction)
    if let timingCurve = traits.timingCurve as? CAMediaTimingFunction {
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.x, linear.mdm_point1.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point1.y, linear.mdm_point1.y, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.x, linear.mdm_point2.x, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.mdm_point2.y, linear.mdm_point2.y, accuracy: 0.001)
    }
    XCTAssertNil(traits.repetition)
  }

  func testInitializerValuesWithDurationDelaySpringTimingCurve() {
    let spring = MDMSpringTimingCurve(mass: 0.7, tension: 0.8, friction: 0.9)
    let traits = MDMAnimationTraits(delay: 0.2, duration: 0.5, timingCurve: spring)

    XCTAssertEqualWithAccuracy(traits.duration, 0.5, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, 0.2, accuracy: 0.001)
    XCTAssertTrue(traits.timingCurve is MDMSpringTimingCurve)
    if let timingCurve = traits.timingCurve as? MDMSpringTimingCurve {
      XCTAssertEqualWithAccuracy(timingCurve.mass, spring.mass, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.friction, spring.friction, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.tension, spring.tension, accuracy: 0.001)
      XCTAssertEqualWithAccuracy(timingCurve.initialVelocity, spring.initialVelocity,
                                 accuracy: 0.001)
    }
    XCTAssertNil(traits.repetition)
  }

  func testInitializerValuesWithDurationDelayNilTimingCurveRepetition() {
    let repetition = MDMRepetition(numberOfRepetitions: 5)
    let traits = MDMAnimationTraits(delay: 0.2,
                                    duration: 0.5,
                                    timingCurve: nil,
                                    repetition: repetition)

    XCTAssertEqualWithAccuracy(traits.duration, 0.5, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(traits.delay, 0.2, accuracy: 0.001)
    XCTAssertNil(traits.timingCurve)
    XCTAssertTrue(traits.repetition is MDMRepetition)
    if let setRepetition = traits.repetition as? MDMRepetition {
      XCTAssertEqualWithAccuracy(setRepetition.numberOfRepetitions, repetition.numberOfRepetitions,
                                 accuracy: 0.001)
      XCTAssertEqual(setRepetition.autoreverses, repetition.autoreverses)
    }
  }

  func testModifyingACopyDoesNotModifyTheOriginal() {
    let spring = MDMSpringTimingCurve(mass: 0.7, tension: 0.8, friction: 0.9)
    let repetition = MDMRepetition(numberOfRepetitions: 5)
    let traits = MDMAnimationTraits(delay: 0.2,
                                    duration: 0.5,
                                    timingCurve: spring,
                                    repetition: repetition)

    let copy = traits.copy() as! MDMAnimationTraits
    copy.delay = copy.delay + 1
    copy.duration = copy.duration + 1
    if let springCopy = copy.timingCurve as? MDMSpringTimingCurve {
      springCopy.friction = springCopy.friction + 1
      springCopy.tension = springCopy.tension + 1
      springCopy.mass = springCopy.mass + 1
      springCopy.initialVelocity = springCopy.initialVelocity + 1

      XCTAssertNotEqualWithAccuracy(springCopy.friction, spring.friction, 0.001)
      XCTAssertNotEqualWithAccuracy(springCopy.tension, spring.tension, 0.001)
      XCTAssertNotEqualWithAccuracy(springCopy.mass, spring.mass, 0.001)
      XCTAssertNotEqualWithAccuracy(springCopy.initialVelocity, spring.initialVelocity, 0.001)
    }
    if let repetitionCopy = copy.repetition as? MDMRepetition {
      repetitionCopy.autoreverses = !repetitionCopy.autoreverses
      repetitionCopy.numberOfRepetitions = repetitionCopy.numberOfRepetitions + 1

      XCTAssertNotEqual(repetitionCopy.autoreverses, repetition.autoreverses)
      XCTAssertNotEqual(repetitionCopy.numberOfRepetitions, repetition.numberOfRepetitions)
    }

    XCTAssertNotEqualWithAccuracy(copy.duration, traits.duration, 0.001)
    XCTAssertNotEqualWithAccuracy(copy.delay, traits.delay, 0.001)
  }
}
