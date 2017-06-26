#
#  Be sure to run `pod spec lint SwiftFullScreenPop.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SwiftFullScreenPop"
  s.version      = "2.0"
  s.summary      = "to resolve custom navigationBar or hide use fullsreenPop on swift3.0"
  s.homepage     = "https://github.com/LeeFengHY/SwiftFullScreenPop"
  s.license      = "MIT"
  s.author       = {"leefenghy" => "578545715@qq.com"}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LeeFengHY/SwiftFullScreenPop.git", :tag => "2.0" }
  s.source_files  = "SwiftFullScreenPop/FullScreenPopGestureRecognizer.swift"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
end
