Pod::Spec.new do |s|
s.name             = "JDAnimationKit"
s.version          = "1.0.1"
s.summary          = "You can animate your UI withe less lines of code"
s.description      = 'JDAnimationKit is designed to be extremely easy to use. You can animate your UI withe less lines of code'
s.homepage         = 'https://github.com/JellyDevelopment/JDAnimationKit'
s.license          = 'MIT'
s.author           = { "Juanpe" => "juanpecm@gmail.com" }
s.source           = { :git => "https://github.com/JellyDevelopment/JDAnimationKit.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/juanpecmios'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'

s.frameworks = 'UIKit'
s.dependency 'pop', '~> 1.0'
end