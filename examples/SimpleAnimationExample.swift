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

import Foundation
import MotionInterchange

// This demo shows how one might use a motion spec structure to define timing for a multi-state
// animation such as the Material "masked transition" motion.

// Our motion specification. Each row of the spec defines strict timing for some part of the
// animation.
struct MaterialMaskedTransitionMotion {
  let floodColorTransformation: MotionTiming
  let maskTransformation: MotionTiming
}

// The motion spec for card expansion.
let cardExpansion = MaterialMaskedTransitionMotion(
  floodColorTransformation: .init(
    delay:    0.075,
    duration: 0.075,
    controlPoints: materialEaseInEaseOut
  ),
  maskTransformation: .init(
    delay:    0.045,
    duration: 0.255,
    controlPoints: materialEaseInEaseOut
  )
)

// The motion spec for card collapse.
let cardCollapse = MaterialMaskedTransitionMotion(
  floodColorTransformation: .init(
    delay:    0.060,
    duration: 0.150,
    controlPoints: materialEaseInEaseOut
  ),
  maskTransformation: .init(
    delay:    0.000,
    duration: 0.180,
    controlPoints: materialEaseInEaseOut
  )
)

class SimpleAnimationExampleViewController: ExampleViewController {

  var isOpen = false
  func didTap(_ button: UIButton) {
    let animator = MotionTimingAnimator()

    // This allows us to define our animation in terms of movement in one direction. When the
    // direction of motion changes, we tell the animator to reverse the values.
    animator.shouldReverseValues = isOpen

    // Pick which motion spec we're using. For more complicated cases we might turn this into a
    // function.
    let motion = isOpen ? cardCollapse : cardExpansion

    isOpen = !isOpen

    animator.addAnimation(with: motion.floodColorTransformation,
                          to: button.layer,
                          withValues: [UIColor.primaryColor, UIColor.secondaryColor],
                          keyPath: "backgroundColor")

    animator.addAnimation(with: motion.maskTransformation,
                          to: button.layer,
                          withValues: [32, 0],
                          keyPath: "cornerRadius")

    animator.addAnimation(with: motion.maskTransformation,
                          to: button.layer,
                          withValues: [CGSize(width: 64, height: 64),
                                       CGSize(width: 128, height: 128)],
                          keyPath: "bounds.size")

    animator.addAnimation(with: motion.maskTransformation,
                          to: button.layer,
                          withValues: [CGSize(width: 64, height: 64),
                                       CGSize(width: 128, height: 128)],
                          keyPath: "bounds.size")

    animator.addAnimation(with: motion.maskTransformation,
                          to: button.layer,
                          withValues: [CGPoint(x: view.bounds.width / 2,
                                               y: view.bounds.height - 64 - 32),
                                       CGPoint(x: view.bounds.width / 2,
                                               y: view.bounds.height - 64 - 64)],
                          keyPath: "position")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let exampleView = UIButton(type: .custom)
    exampleView.backgroundColor = .primaryColor
    exampleView.bounds = CGRect(origin: .zero, size: .init(width: 64, height: 64))
    exampleView.center = .init(x: view.bounds.width / 2,
                               y: view.bounds.height - exampleView.bounds.height - 32)
    exampleView.layer.cornerRadius = exampleView.bounds.width / 2
    exampleView.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    view.addSubview(exampleView)
  }

  override func exampleInformation() -> ExampleInfo {
    return .init(title: type(of: self).catalogBreadcrumbs().last!,
                 instructions: "Tap to present a modal transition.")
  }
}

let materialEaseInEaseOut: (Float, Float, Float, Float) = (0.4, 0.0, 0.2, 1.0)
