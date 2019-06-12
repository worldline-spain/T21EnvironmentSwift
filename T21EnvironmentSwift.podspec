Pod::Spec.new do |s|
  s.name			= "T21EnvironmentSwift"
  s.version			= "2.0.0"
  s.summary			= "This class provides helper methods to deal with app deployment related stuff."
  s.author			= "Eloi Guzman Ceron"
  s.platform			= :ios
  s.ios.deployment_target	= "10.0"
  s.tvos.deployment_target	= "10.0"
  s.source      		= { :git => "https://github.com/worldline-spain/T21EnvironmentSwift.git", :tag => s.version }
  s.source_files		= "src/**/*.{swift}"
  s.framework			= "Foundation", "UIKit"
  s.requires_arc		= true
  s.homepage			= "https://github.com/worldline-spain/T21EnvironmentSwift"
  s.license			= "https://github.com/worldline-spain/T21EnvironmentSwift/blob/master/LICENSE"
  s.swift_version		= '5.0'

  s.dependency			"T21Notifier", "~>2.0.2"
  s.dependency			"T21LoggerSwift", "~>2.0.0"
end
