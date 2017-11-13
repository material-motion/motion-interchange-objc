# 1.4.0

This minor release introduces new APIs for creating springs that have an initial velocity.

## New features

Added new APIs for creating springs with initial velocity:
`MDMMotionCurveMakeSpringWithInitialVelocity` and `_MDMSpringWithInitialVelocity`.

## Source changes

* [Add new APIs for creating springs with initial velocity. (#19)](https://github.com/material-motion/motion-interchange-objc/commit/326180f9f5f99e7d5e9e23131de8c24abe2e1dbf) (featherless)

## API changes

### MDMMotionCurveMakeSpringWithInitialVelocity

**new** function: `MDMMotionCurveMakeSpringWithInitialVelocity`

### _MDMSpringWithInitialVelocity

**new** macro: `_MDMSpringWithInitialVelocity`

## Non-source changes

* [Add sdk_frameworks dependencies to the BUILD file. (#18)](https://github.com/material-motion/motion-interchange-objc/commit/a601fb65166426bc708d84c0e29d89913c445d04) (featherless)
* [Add jazzy yaml.](https://github.com/material-motion/motion-interchange-objc/commit/130e9760bbb8c0e2179f820cc14f1278c9465b84) (Jeff Verkoeyen)

# 1.3.0

This minor releases introduces new APIs for defining motion curves.

## New deprecations

`MDMMotionCurveTypeDefault` is now deprecated. Use `MDMMotionCurveTypeBezier` instead.

## New features

The new `MDMLinearMotionCurve` macro allows you to define linear easing curves in specs.

Spring curve specs can now define initial velocity. This value can be read using the new
`MDMSpringMotionCurveDataIndexInitialVelocity` enum value for `MDMSpringMotionCurveDataIndex`.

## Source changes

* [Document and define the initial velocity parameter of spring curves (#17)](https://github.com/material-motion/motion-interchange-objc/commit/7eb5e2f79229c3b7cdada7b8df3e1e66b7e229e5) (featherless)
* [Add a linear curve constant. (#16)](https://github.com/material-motion/motion-interchange-objc/commit/0aa4f8caff7314310c3cbd721814305ee6f53601) (featherless)
* [Deprecate MDMMotionCurveTypeDefault in favor of MDMMotionCurveTypeBezier. (#15)](https://github.com/material-motion/motion-interchange-objc/commit/f5a7f3b4a63d4643700403930e2cafd7d4482013) (featherless)

## API changes

### MDMSpringMotionCurveDataIndexInitialVelocity

**new** enum: `MDMSpringMotionCurveDataIndexInitialVelocity`.

### MDMLinearMotionCurve

**new** constant/macro: `MDMLinearMotionCurve`.

# 1.2.0

This minor release introduces a new API for reversing cubic beziers and a unit test for
`MDMModalMovementTiming`.

## New features

`MDMMotionCurveReversedBezier` reverses cubic bezier curves. Intended for use when building mirrored
bi-directional transitions.

## Source changes

* [Add a unit test for MDMModalMovementTiming. (#12)](https://github.com/material-motion/motion-interchange-objc/commit/a0c3566ad52a45365657e0591701afa7989eb822) (featherless)
* [Add MDMMotionCurveReversed for reversing timing curves. (#11)](https://github.com/material-motion/motion-interchange-objc/commit/a54a5ffa49052a198b4bb5beedce737bb61ebc91) (featherless)

## API changes

### MDMMotionCurveReversedBezier

**new** function: `MDMMotionCurveReversedBezier`.

## Non-source changes

* [Standardize the kokoro and bazel files. (#13)](https://github.com/material-motion/motion-interchange-objc/commit/a009d3f7d08d8b2d087891a86eb1e298714198b4) (featherless)
* [Use the v1.0.0 tag for bazel_ios_warnings. (#10)](https://github.com/material-motion/motion-interchange-objc/commit/545b6a448ddb235279318dc262f051d653a48ed4) (featherless)

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
