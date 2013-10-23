Pod::Spec.new do |s|
  s.name         = "TokenKit"
  s.version      = "0.0.2"
  s.summary      = "UICollectionView-driven token field built for customization."
  s.homepage     = "https://github.com/radi/TokenKit"
  s.author       = { "Evadne Wu" => "ev@radi.ws" }
  s.source       = { :git => "https://github.com/radi/TokenKit.git", :tag => "0.0.2" }
  s.platform     = :ios, '6.0'
  s.source_files = 'TokenKit', 'TokenKit/**/*.{h,m}'
  s.frameworks = 'QuartzCore', 'UIKit'
  s.requires_arc = true
end
