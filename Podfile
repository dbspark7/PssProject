# source 'https://github.com/CocoaPods/Specs.git'
# Uncomment the next line to define a global platform for your project

platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!

workspace 'PssProject'
project 'EasyD-Day/EasyD-Day.project'
project 'RawMaterialPrice/RawMaterialPrice.project'
project 'PssCore/PssCore.project'

def commonPods
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Crashlytics'
end

target 'EasyD-Day' do
  project 'EasyD-Day/EasyD-Day.project'
  commonPods

  target 'EasyD-DayTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'EasyD-DayUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'RawMaterialPrice' do
  project 'RawMaterialPrice/RawMaterialPrice.project'
  commonPods

  target 'RawMaterialPriceTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RawMaterialPriceUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'PssCore' do
  project 'PssCore/PssCore.project'
  commonPods
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['ENABLE_NS_ASSERTIONS'] = 'NO'
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['ENABLE_NS_ASSERTIONS'] = 'NO'
    end
  end
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DEVELOPMENT_TEAM'] = 'WY5E8U82TN'
         end
    end
  end
end