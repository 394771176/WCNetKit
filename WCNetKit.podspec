#
# Be sure to run `pod lib lint WCNetKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WCNetKit'
  s.version          = '0.1.5'
  s.summary          = 'A short description of WCNetKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '网络请求库封装，ASI'

  s.homepage         = 'https://github.com/394771176/WCNetKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '394771176' => '394771176@qq.com' }
  s.source           = { :git => 'https://github.com/394771176/WCNetKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

s.source_files = [
  'WCNetKit/Classes/*.h',
  'WCNetKit/Classes/*.m',
  ]
  
  # s.resource_bundles = {
  #   'WCNetKit' => ['WCNetKit/Assets/*.png']
  # }

   s.public_header_files = [
   'WCNetKit/Classes/*.h'
   ]
   
   # OpenUDID
   s.subspec 'OpenUDID' do |udid|
       udid.source_files = [
       'WCNetKit/Classes/OpenUDID/*.h',
       'WCNetKit/Classes/OpenUDID/*.m',
       ]
       udid.public_header_files = [
       'WCNetKit/Classes/OpenUDID/*.h',
       ]
       udid.requires_arc = false
   end
   
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'WCCategory'
  s.dependency 'WCModel/Entity'
  s.dependency 'WCModel/Cache'
  s.dependency 'WCModule/ASIHttpRequest'
  
end
