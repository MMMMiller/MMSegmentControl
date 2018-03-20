Pod::Spec.new do |s|
  s.name         = 'MMSegmentControl'
  s.summary      = 'A segmentControl for iOS.'
  s.version      = '0.0.3'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'MMMille' => 'xuemingluan@gmail.com' }
  #s.social_media_url = 'http://blog.MMMille.com'
  s.homepage     = 'https://github.com/MMMille/MMSegmentControl'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/MMMille/MMSegmentControl.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'MMSegmentControl/**/*.{h,m}'

  s.libraries = 'z', 'sqlite3'
  s.frameworks = 'UIKit', 'CoreFoundation'
  s.dependency 'Masonry'
end
#pod trunk push MMSegmentControl.podspec --allow-warnings