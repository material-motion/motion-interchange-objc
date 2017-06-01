Pod::Spec.new do |s|
  s.name         = "MotionInterchange"
  s.summary      = "Motion interchange format."
  s.version      = "1.0.0"
  s.authors      = "The Material Motion Authors"
  s.license      = "Apache 2.0"
  s.homepage     = "https://github.com/material-motion/motion-interchange-objc"
  s.source       = { :git => "https://github.com/material-motion/motion-interchange-objc.git", :tag => "v" + s.version.to_s }
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.subspec "Interchange" do |ss|
    ss.public_header_files = "src/*.h"
    ss.source_files = "src/interchange/*.{h,m,mm}", "src/interchange/private/*.{h,m,mm}"
  end

  s.subspec "Animator" do |ss|
    ss.public_header_files = "src/*.h"
    ss.source_files = "src/animator/*.{h,m,mm}", "src/animator/private/*.{h,m,mm}"
    
    ss.dependency "MotionInterchange/Interchange"
  end

end
