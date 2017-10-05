# Description:
# Motion interchange format.

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

objc_library(
    name = "MotionInterchange",
    srcs = glob([
        "src/*.m",
        "src/private/*.m",
    ]),
    hdrs = glob([
        "src/*.h",
        "src/private/*.h",
    ]),
    enable_modules = 1,
    includes = ["src"],
    visibility = ["//visibility:public"],
    copts = [
        "-Wall",  # Standard known-to-be-bugs warnings.
        "-Wcast-align",  # Casting a pointer such that alignment is broken.
        "-Wconversion",  # Numeric conversion warnings.
        "-Wdocumentation",  # Documentation checks.
        "-Werror",  # All warnings as errors.
        "-Wextra",  # Many useful extra warnings.
        "-Wimplicit-atomic-properties",  # Dynamic properties should be non-atomic.
        "-Wmissing-prototypes",  # Global function is defined without a previous prototype.
        "-Wno-error=deprecated",  # Deprecation warnings are never errors.
        "-Wno-error=deprecated-implementations",  # Deprecation warnings are never errors.
        "-Wno-sign-conversion",  # Do not warn on sign conversions.
        "-Wno-unused-parameter",  # Do not warn on unused parameters.
        "-Woverlength-strings",  # Strings longer than the C maximum.
        "-Wshadow",  # Local variable shadows another variable, parameter, etc.
        "-Wstrict-selector-match",  # Compiler can't figure out the right selector.
        "-Wundeclared-selector",  # Compiler doesn't see a selector.
        "-Wunreachable-code",  # Code will never be reached.
    ]
)

load("@build_bazel_rules_apple//apple:swift.bzl", "swift_library")

swift_library(
    name = "UnitTestsSwiftLib",
    srcs = glob([
        "tests/unit/*.swift",
    ]),
    deps = [":MotionInterchange"],
    visibility = ["//visibility:private"],
)

objc_library(
    name = "UnitTestsLib",
    srcs = glob([
        "tests/unit/*.m",
    ]),
    deps = [":MotionInterchange"],
    visibility = ["//visibility:private"],
)

load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")

ios_unit_test(
    name = "UnitTests",
    deps = [
      ":UnitTestsLib",
      ":UnitTestsSwiftLib"
    ],
    minimum_os_version = "8.0",
    timeout = "short",
    visibility = ["//visibility:private"],
)
