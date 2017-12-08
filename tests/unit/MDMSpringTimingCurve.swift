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

  @available(iOS 9.0, *)
  func testInitializerValuesWithDampingCoefficient() {
    for duration in stride(from: TimeInterval(0.1), to: TimeInterval(3), by: TimeInterval(0.5)) {
      for dampingRatio in stride(from: CGFloat(0.1), to: CGFloat(2), by: CGFloat(0.4)) {
        for initialVelocity in stride(from: CGFloat(-2), to: CGFloat(2), by: CGFloat(0.8)) {
          let curve = MDMSpringTimingCurve(duration: duration,
                                           dampingRatio: dampingRatio,
                                           initialVelocity: initialVelocity)
          let view = UIView()

          UIView.animate(withDuration: duration,
                         delay: 0,
                         usingSpringWithDamping: dampingRatio,
                         initialSpringVelocity: initialVelocity,
                         options: [],
                         animations: {
                          view.center = CGPoint(x: initialVelocity * 5, y: dampingRatio * 10)
          }, completion: nil)

          if let animationKey = view.layer.animationKeys()?.first,
            let animation = view.layer.animation(forKey: animationKey) as? CASpringAnimation {

            XCTAssertEqualWithAccuracy(curve.mass, animation.mass, accuracy: 0.001)
            XCTAssertEqualWithAccuracy(curve.tension, animation.stiffness, accuracy: 0.001)
            XCTAssertEqualWithAccuracy(curve.friction, animation.damping, accuracy: 0.001)
            XCTAssertEqualWithAccuracy(curve.initialVelocity, animation.initialVelocity, accuracy: 0.001)
          }
        }
      }
    }
  }

  func testChangingInitialVelocityInvalidatesTheCoefficients() {
    let curve = MDMSpringTimingCurve(duration: 0.5,
                                     dampingRatio: 0.8,
                                     initialVelocity: 0)

    let originalMass = curve.mass
    let originalTension = curve.tension
    let originalFriction = curve.friction

    curve.initialVelocity = 10

    // UIKit never appears to change the mass.
    XCTAssertEqualWithAccuracy(curve.mass, originalMass, accuracy: 0.001)
    XCTAssertNotEqualWithAccuracy(curve.tension, originalTension, 0.001)
    XCTAssertNotEqualWithAccuracy(curve.friction, originalFriction, 0.001)
  }

  func testWithDampingRatioSettingMassKeepsTheNewMass() {
    let curve = MDMSpringTimingCurve(duration: 0.5,
                                     dampingRatio: 0.8,
                                     initialVelocity: 0)

    let originalMass = curve.mass
    let originalTension = curve.tension
    let originalFriction = curve.friction

    curve.mass = originalMass + 1

    XCTAssertEqualWithAccuracy(curve.mass, originalMass + 1, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.tension, originalTension, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.friction, originalFriction, accuracy: 0.001)
  }

  func testWithDampingRatioSettingTensionKeepsTheNewTension() {
    let curve = MDMSpringTimingCurve(duration: 0.5,
                                     dampingRatio: 0.8,
                                     initialVelocity: 0)

    let originalMass = curve.mass
    let originalTension = curve.tension
    let originalFriction = curve.friction

    curve.tension = originalTension + 1

    XCTAssertEqualWithAccuracy(curve.mass, originalMass, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.tension, originalTension + 1, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.friction, originalFriction, accuracy: 0.001)
  }

  func testWithDampingRatioSettingFrictionKeepsTheNewFriction() {
    let curve = MDMSpringTimingCurve(duration: 0.5,
                                     dampingRatio: 0.8,
                                     initialVelocity: 0)

    let originalMass = curve.mass
    let originalTension = curve.tension
    let originalFriction = curve.friction

    curve.friction = originalFriction + 1

    XCTAssertEqualWithAccuracy(curve.mass, originalMass, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.tension, originalTension, accuracy: 0.001)
    XCTAssertEqualWithAccuracy(curve.friction, originalFriction + 1, accuracy: 0.001)
  }
}
