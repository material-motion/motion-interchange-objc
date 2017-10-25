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

#import <XCTest/XCTest.h>

#import "MotionInterchange.h"

@interface MDMModalMovementTimingTests : XCTestCase
@property(nonatomic, strong) UIWindow *window;
@end

@interface ModalPresentationExtractionViewController : UIViewController
@property(nonatomic, strong) CAAnimation *presentationPositionAnimation;
@end

@implementation ModalPresentationExtractionViewController

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  // We just want the first position key path animation that affects this view controller.
  if (!self.presentationPositionAnimation) {
    self.presentationPositionAnimation = [self.view.layer animationForKey:@"position"];
  }
}

@end

@implementation MDMModalMovementTimingTests

- (void)setUp {
  [super setUp];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  [self.window makeKeyAndVisible];
}

- (void)tearDown {
  self.window = nil;

  [super tearDown];
}

- (void)testSystemModalMovementTimingCurveMatchesModalMovementTiming {
  ModalPresentationExtractionViewController *presentedViewController =
      [[ModalPresentationExtractionViewController alloc] initWithNibName:nil bundle:nil];
  XCTestExpectation *didComplete = [self expectationWithDescription:@"Animation completed"];
  [self.window.rootViewController presentViewController:presentedViewController
                                               animated:YES
                                             completion:^{
                                               [didComplete fulfill];
                                             }];

  [self waitForExpectationsWithTimeout:1 handler:nil];

  XCTAssertTrue([presentedViewController.presentationPositionAnimation
                 isKindOfClass:[CASpringAnimation class]]);
  CASpringAnimation *springAnimation =
      (CASpringAnimation *)presentedViewController.presentationPositionAnimation;

  MDMMotionTiming timing = MDMModalMovementTiming;
  XCTAssertEqualWithAccuracy(timing.curve.data[MDMSpringMotionCurveDataIndexMass],
                             springAnimation.mass,
                             0.001);
  XCTAssertEqualWithAccuracy(timing.curve.data[MDMSpringMotionCurveDataIndexTension],
                             springAnimation.stiffness,
                             0.001);
  XCTAssertEqualWithAccuracy(timing.curve.data[MDMSpringMotionCurveDataIndexFriction],
                             springAnimation.damping,
                             0.001);
}

@end
