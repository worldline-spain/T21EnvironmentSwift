
Pod::Spec.new do |s|

  s.name         = "T21EnvironmentSwift"
  s.version      = "1.1.2"
  s.summary      = "This class provides helper methods to deal with app deployment related stuff, such as build configuration dependent variables and also, language runtime management support."
  s.author    = "Eloi Guzman Ceron"
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/worldline-spain/T21EnvironmentSwift.git", :tag => "1.1.2" }
  s.source_files  = "src/**/*.{swift}"
  s.framework  = "Foundation", "UIKit"
  s.requires_arc = true
  s.homepage = "https://github.com/worldline-spain/T21EnvironmentSwift"
  s.license = "https://github.com/worldline-spain/T21EnvironmentSwift/blob/master/LICENSE"
  s.dependency  "T21Notifier", "~>1.0.3"
  s.dependency  "T21LoggerSwift", "~>1.2.1"


end
