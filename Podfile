# source 'https://github.com/CocoaPods/Specs.git'
# Uncomment the next line to define a global platform for your project

platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!

workspace 'PssProject'
project 'EasyD-Day/EasyD-Day.project'
project 'RawMaterialPrice/RawMaterialPrice.project'
project 'VideoDecibel/VideoDecibel.project'
project 'PssCore/PssCore.project'
project 'PssLogger/PssLogger.project'

def commonPods1
  pod 'RxSwift', '6.1.0'
  pod 'RxCocoa', '6.1.0'
end

def commonPods2
  pod 'MaterialComponents/ActivityIndicator'
  pod 'MaterialComponents/AppBar'
  pod 'MaterialComponents/BottomNavigation'
  pod 'MaterialComponents/Snackbar'
  pod 'M13Checkbox'

  pod 'SnapKit', '5.0.1'
end

def commonPods3
  pod 'CocoaLumberjack/Swift'
end

target 'EasyD-Day' do
  project 'EasyD-Day/EasyD-Day.project'
  commonPods1
  commonPods2
  commonPods3

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
  commonPods1
  commonPods2
  commonPods3

  target 'RawMaterialPriceTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RawMaterialPriceUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'VideoDecibel' do
  project 'VideoDecibel/VideoDecibel.project'
  commonPods1
  commonPods2
  commonPods3
  pod 'Charts'

  target 'VideoDecibelTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VideoDecibelUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'PssCore' do
  project 'PssCore/PssCore.project'
  commonPods1
  commonPods2
  commonPods3
end

target 'PssLogger' do
  project 'PssLogger/PssLogger.project'
  commonPods3
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
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
            config.build_settings["DEVELOPMENT_TEAM"] = "WY5E8U82TN"
         end
    end
  end
end