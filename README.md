![Motion Interchange Banner](img/motion-interchange-banner.gif)

> A standard format for animation traits in Objective-C and Swift.

[![Build Status](https://travis-ci.org/material-motion/motion-interchange-objc.svg?branch=develop)](https://travis-ci.org/material-motion/motion-interchange-objc)
[![codecov](https://codecov.io/gh/material-motion/motion-interchange-objc/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-motion/motion-interchange-objc)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MotionInterchange.svg)](https://cocoapods.org/pods/MotionInterchange)
[![Platform](https://img.shields.io/cocoapods/p/MotionInterchange.svg)](http://cocoadocs.org/docsets/MotionInterchange)

"Magic numbers" — those lonely, abandoned values without a home — are often one of the first things
targeted in code review for cleanup. And yet, numbers related to animations may go unnoticed and
left behind, scattered throughout a code base with little to no organizational diligence. These
forgotten metrics form the backbone of mobile interactions and are often the ones needing the most
care - so why are we ok leaving them scattered throughout a code base?

```objc
// Let's play "find the magic number": how many magic numbers are hidden in this code?
[UIView animateWithDuration:0.230
                      delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                      animations:^{
                        myButton.position = updatedPosition;
                      }
                      completion:nil];
// Hint: the answer is not "one, the number 0.230".
```

The challenge with extracting animation magic numbers is that we often don't have a clear
definition of *what an animation is composed of*. An animation is not simply determined by its
duration, in the same way that a color is not simply determined by how red it is.

The traits of an animation — like the red, green, and blue components of a color — include the
following:

- Delay.
- Duration.
- Timing curve.
- Repetition.

Within this library you will find simple data types for storing and representing animation
traits so that the lost magic numbers for animation your code can find a place to call home.

Welcome home, lost numbers.

## Sibling library: Motion Animator

While it is possible to use the Motion Interchange as a standalone library, the Motion Animator
is designed to be the primary consumer of Motion Interchange data types. Consider using these
libraries together, with MotionAnimator as your primary dependency.

```objc
MDMAnimationTraits *animationTraits =
    [[MDMAnimationTraits alloc] initWithDuration:0.230
                              timingFunctionName:kCAMediaTimingFunctionEaseInEaseOut];

MDMMotionAnimator *animator = [[MDMMotionAnimator alloc] init];
[animator animateWithTraits:animationTraits animations:^{
  view.alpha = 0;
}];
```

To learn more, visit the MotionAnimator GitHub page:

https://github.com/material-motion/motion-animator-objc

## Installation

### Installation with CocoaPods

> CocoaPods is a dependency manager for Objective-C and Swift libraries. CocoaPods automates the
> process of using third-party libraries in your projects. See
> [the Getting Started guide](https://guides.cocoapods.org/using/getting-started.html) for more
> information. You can install it with the following command:
>
>     gem install cocoapods

Add `MotionInterchange` to your `Podfile`:

    pod 'MotionInterchange'

Then run the following command:

    pod install

### Usage

Import the framework:

    @import MotionInterchange;

You will now have access to all of the APIs.

## Example apps/unit tests

Check out a local copy of the repo to access the Catalog application by running the following
commands:

    git clone https://github.com/material-motion/motion-interchange-objc.git
    cd motion-interchange-objc
    pod install
    open MotionInterchange.xcworkspace

## Guides

1. [Architecture](#architecture)
2. [How to define a cubic bezier animation](#how-to-define-a-cubic-bezier-animation)
3. [How to define a spring animation](#how-to-define-a-spring-animation)
4. [How to define a motion spec](#how-to-define-a-motion-spec)

### Architecture

This library defines a format for representing motion in Objective-C and Swift applications. The
primary data type, `MotionTiming`, allows you to describe the duration, delay, timing curve, and
repetition for an animation.

### How to define a cubic bezier animation

In Objective-C:

```objc
MDMMotionTiming timing = (MDMMotionTiming){
  .delay = 0.150,
  .duration = 0.225,
  .curve = _MDMBezier(0.4f, 0.0f, 0.2f, 1.0f)
}
```

### How to define a spring animation

In Objective-C:

```objc
MDMMotionTiming timing = (MDMMotionTiming){
  .curve = _MDMSpring(1, 100, 10)
}
```

### How to define a motion spec

Motion timing structs can be used to represent complex multi-element and multi-property motion
specifications. An example of a common complex motion spec is a transition which has both an
expansion and a collapse variant. If we wanted to represent such a transition we might create a
set of structures like this:

```objc
struct MDCMaskedTransitionMotionTiming {
  MDMMotionTiming contentFade;
  MDMMotionTiming floodBackgroundColor;
  MDMMotionTiming maskTransformation;
  MDMMotionTiming horizontalMovement;
  MDMMotionTiming verticalMovement;
  MDMMotionTiming scrimFade;
};
typedef struct MDCMaskedTransitionMotionTiming MDCMaskedTransitionMotionTiming;

struct MDCMaskedTransitionMotionSpec {
  MDCMaskedTransitionMotionTiming expansion;
  MDCMaskedTransitionMotionTiming collapse;
  BOOL shouldSlideWhenCollapsed;
  BOOL isCentered;
};
typedef struct MDCMaskedTransitionMotionSpec MDCMaskedTransitionMotionSpec;
```

We can then implement a spec like so:

```objc
#define MDMEightyForty _MDMBezier(0.4f, 0.0f, 0.2f, 1.0f)
#define MDMFortyOut _MDMBezier(0.4f, 0.0f, 1.0f, 1.0f)

struct MDCMaskedTransitionMotionSpec fullscreen = {
  .expansion = {
    .contentFade = {
      .delay = 0.150, .duration = 0.225, .curve = MDMEightyForty,
    },
    .floodBackgroundColor = {
      .delay = 0.000, .duration = 0.075, .curve = MDMEightyForty,
    },
    .maskTransformation = {
      .delay = 0.000, .duration = 0.105, .curve = MDMFortyOut,
    },
    .horizontalMovement = {.curve = { .type = MDMMotionCurveTypeInstant }},
    .verticalMovement = {
      .delay = 0.045, .duration = 0.330, .curve = MDMEightyForty,
    },
    .scrimFade = {
      .delay = 0.000, .duration = 0.150, .curve = MDMEightyForty,
    }
  },
  .shouldSlideWhenCollapsed = true,
  .isCentered = false
};
```

We can then use this motion spec to implement our animations in a transition like so:

```objc
MDCMaskedTransitionMotionTiming timing = isExpanding ? fullscreen.expansion : fullscreen.collapse;

// Can now use timing's properties to associate animations with views.
```

## Contributing

We welcome contributions!

Check out our [upcoming milestones](https://github.com/material-motion/motion-interchange-objc/milestones).

Learn more about [our team](https://material-motion.github.io/material-motion/team/),
[our community](https://material-motion.github.io/material-motion/team/community/), and
our [contributor essentials](https://material-motion.github.io/material-motion/team/essentials/).

## License

Licensed under the Apache 2.0 license. See LICENSE for details.
