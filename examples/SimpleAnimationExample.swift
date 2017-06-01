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

let materialEaseInEaseOut: (Float, Float, Float, Float) = (0.4, 0.0, 0.2, 1.0)

// This demo shows how one might use a motion spec structure to define timing for a multi-state
// animation such as the Material "masked transition" motion.

// Our motion specification. Each row of the spec defines strict timing for some part of the
// animation.
class MaterialMaskedTransitionMotion: AnimationConfigurator {
  init(floodColorTransformation: MotionTiming, maskTransformation: MotionTiming) {
    self.floodColorTransformation = floodColorTransformation
    self.maskTransformation = maskTransformation
  }

  func timing(forProperty property: String) -> MotionTiming {
    switch property {
    case "backgroundColor": return floodColorTransformation
    case "position": return maskTransformation
    case "cornerRadius": return maskTransformation
    case "size": return maskTransformation
    default:
      assertionFailure("Unknown key")
      return MotionTimingNone
    }
  }

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

  var button: UIButton!
  var isOpen = false
  func didTap() {
    isOpen = !isOpen

    button.animator.animate(toState: isOpen ? "open" : "closed") { didComplete in
      print("Done \(didComplete)")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    button = UIButton(type: .custom)
    button.backgroundColor = .primaryColor
    button.bounds = CGRect(origin: .zero, size: .init(width: 64, height: 64))
    button.center = .init(x: view.bounds.width / 2,
                          y: view.bounds.height - button.bounds.height - 32)
    button.layer.cornerRadius = button.bounds.width / 2
    view.addSubview(button)

    button.animator.states["open"] = [
      "backgroundColor": UIColor.secondaryColor,
      "cornerRadius": 0,
      "size": CGSize(width: 128, height: 128),
      "position": CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 64 - 64)
    ]
    button.animator.states["closed"] = [
      "backgroundColor": UIColor.primaryColor,
      "cornerRadius": 32,
      "size": CGSize(width: 64, height: 64),
      "position": CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 64 - 32)
    ]
    button.animator.configurationForState["open"] = cardExpansion
    button.animator.configurationForState["closed"] = cardCollapse

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    view.addGestureRecognizer(tap)
  }

  override func exampleInformation() -> ExampleInfo {
    return .init(title: type(of: self).catalogBreadcrumbs().last!,
                 instructions: "Tap to present a modal transition.")
  }
}
