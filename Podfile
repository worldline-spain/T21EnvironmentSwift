source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/worldline-spain/t21_pods-specs_ios.git'

workspace 'T21Environment'
project 'T21Environment'

target 'T21Environment' do

	#Dependencies for the primary target (the main app or the main library)
	use_frameworks!

	pod 'T21LoggerSwift'
    pod 'T21Notifier'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
		end
	end
end


