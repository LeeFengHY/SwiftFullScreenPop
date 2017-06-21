#
#  Be sure to run `pod spec lint SwiftFullScreenPop.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SwiftFullScreenPop"
  s.version      = "1.0.0"
  s.summary      = "Swift3.0 use it to resolve navigationController interactivePopGestureRecognizer can't use when a custom navigationBar or used leftBarButtonItem to back and hidden navigationBar caused bug"
  s.homepage     = "https://github.com/LeeFengHY/SwiftFullScreenPop"
  s.license      = "MIT"
  s.author       = { "leefenghy" => "578545715@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LeeFengHY/SwiftFullScreenPop.git", :tag => "#{s.version}" }
  s.source_files  = "SwiftFullScreenPop/NavigationController+FullscreenPopGesture.swift"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
