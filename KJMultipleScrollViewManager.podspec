#
#  Be sure to run `pod spec lint KJMultipleScrollViewManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "KJMultipleScrollViewManager"
  s.version      = "0.0.1"
  s.summary      = "微博主页效果方案之一、UITableView头部下拉放大、多个UIScrollView在同一个页面展示的管理"
  s.homepage     = "https://github.com/hkjin/KJMultipleScrollViewManager"
  s.license      = "MIT"
  s.author             = { "Kegem" => "kegem@foxmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/hkjin/KJMultipleScrollViewManager.git", :tag => "#{s.version}" }
  s.source_files  = "MultipleScrollViewManager/*.{h,m}"
  s.framework  = "UIKit"

end
