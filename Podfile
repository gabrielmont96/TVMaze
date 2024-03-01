# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'TVMaze' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SDWebImage', '5.19.0'
  pod 'SwiftLint', '0.54.0'
  pod 'SnapKit', '5.7.1'

  target 'TVMazeTests' do
    inherit! :search_paths
  end

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end
