#
# Be sure to run `pod lib lint JDAnimationKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JDAnimationKit"
  s.version          = "1.0"
  s.summary          = "JDAnimationKit is designed to be extremely easy to use. You can animate your UI withe less lines of code"
  s.description      = "JDAnimationKit is designed to be extremely easy to use. You can animate your UI withe less lines of code"

  s.homepage         = "https://github.com/JellyDevelopment/JDAnimationKit"
  s.license          = 'MIT'
  s.author           = { "Juanpe" => "juanpecm@gmail.com" }
  s.source           = { :git => "https://github.com/JellyDevelopment/JDAnimationKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/juanpecmios'

  s.platform     = :ios, '8.3'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'JDAnimationKit' => ['Pod/Assets/*.png']
  }

  s.dependency 'pop', '~> 1.0'
end
