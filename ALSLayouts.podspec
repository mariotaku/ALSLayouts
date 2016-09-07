#
# Be sure to run `pod lib lint ALSLayouts.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALSLayouts'
  s.version          = '0.2.1'
  s.summary          = 'AutoLayout Alternative ported from Android'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
If you need a good AutoLayout alternative, try ALSLayouts.
It provides several layout ported from Android, like FrameLayout, LinearLayout and RelativeLayout.
You can specify layout parameters (constraints) in Interface Builder, or just add by code directly.
                       DESC

  s.homepage         = 'https://github.com/mariotaku/ALSLayouts'
  s.screenshots     = 'https://github.com/mariotaku/ALSLayouts/raw/master/Resources/6_layouts.png'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Mariotaku Lee' => 'mariotaku.lee@gmail.com' }
  s.source           = { :git => 'https://github.com/mariotaku/ALSLayouts.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mariotaku'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ALSLayouts/Classes/**/*'

end
