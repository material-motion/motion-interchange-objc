# 1.1.1

This patch release migrates the project's continuous integration pipeline from arc to bazel and
kokoro.

## New features

Continuous integration can now be run locally by executing `./.kokoro` from the root of the git
repo. Requires [bazel](http://bazel.io/).

## Source changes

* [Replace arc with bazel and Kokoro continuous integration. (#9)](https://github.com/material-motion/motion-interchange-objc/commit/2ef4dfbf95a7beb3f0e323e259576b6797420202) (featherless)
* [Fix warning in unit tests. (#8)](https://github.com/material-motion/motion-interchange-objc/commit/d3203a2857648f74d478525514c0f10cb6552b19) (featherless)
* [Add missing import.](https://github.com/material-motion/motion-interchange-objc/commit/445091dbbd68cd0a75e4dd86195cb431b0717e71) (Jeff Verkoeyen)

# 1.1.0

This minor release introduces two new APIs for working with timing curves.

## New features

- `MDMMotionCurveFromTimingFunction` can create a timing curve from a `CAMediaTimingFunction`.
- `MDMModalMovementTiming` is the iOS timing curve for modal presentation movement.

## Source changes

* [Add MDMMotionCurveFromTimingFunction for creating motion curves from timing functions. (#7)](https://github.com/material-motion/motion-interchange-objc/commit/5e9837cb453f354609f574e42c3c7cf69d4e2796) (featherless)
* [Add system timing constant for movement during modal presentation. (#4)](https://github.com/material-motion/motion-interchange-objc/commit/bf757fe5dac65f9e76778d57988689b908a6c69b) (featherless)

## API changes

*new* function: `MDMMotionCurveFromTimingFunction`.

*new* macro: `MDMModalMovementTiming`.

## Non-source changes

* [Update Xcode project settings.](https://github.com/material-motion/motion-interchange-objc/commit/d932efd547276084a09334f38595a3f8da28205d) (Jeff Verkoeyen)
* [Update Podfile.lock.](https://github.com/material-motion/motion-interchange-objc/commit/07f701eb6918752c29f381a028080c5c12511474) (Jeff Verkoeyen)

# 1.0.1

Added a missing framework header for Objective-C support.

## Source changes

* [Add missing framework header.](https://github.com/material-motion/motion-interchange-objc/commit/03a9b2592e805f06eb622238d7ce8ad7e6f56e90) (Jeff Verkoeyen)

## Non-source changes

* [Fix links in readme.](https://github.com/material-motion/motion-interchange-objc/commit/a438194edb51214fca13955fc2badcd93f587ec5) (Jeff Verkoeyen)

# 1.0.0

Initial release.

Includes MotionTiming structure for representing cubic bezier and spring animations.

## Source changes

* [Initial commit of motion interchange format. (#1)](https://github.com/material-motion/motion-interchange-objc/commit/e1d882b11f1ecdd3edf5c8746c8d243939ea097a) (featherless)
