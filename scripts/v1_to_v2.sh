#!/bin/bash
#
# Copyright 2017-present The Material Motion Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Migration script from v1 to v2 interchange APIs.

if [ "$#" -ne 1 ]; then
  echo "Usage: $(basename $0) <path>"
  exit 1
fi

search_path="$1"

replace_objc() {
  find "$search_path" -type f -name "*.h" | xargs sed -i '' "$1"
  find "$search_path" -type f -name "*.m" | xargs sed -i '' "$1"
}

replace_swift() {
  find "$search_path" -type f -name "*.swift" | xargs sed -i '' "$1"
}

replace_all() {
  replace_objc "$1"
  replace_swift "$1"
}

replace_all "s/timing.curve/traits.timingCurve/g"
replace_all "s/traits.curve/traits.timingCurve/g"
replace_objc "s/MDMMotionTiming/MDMAnimationTraits */g"
replace_swift "s/MotionTiming/MDMAnimationTraits/g"
