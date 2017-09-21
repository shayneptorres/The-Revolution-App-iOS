# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Rev FBC' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Rev FBC
  pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', :submodules => true
  
  pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', :submodules => true
  
  pod 'SwiftDate'
  pod 'SwiftyTimer'
  pod 'Alamofire', '~> 4.4'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'JVFloatLabeledTextField'
  pod 'Eureka', git: 'https://git@github.com:xmartlabs/Eureka.git', branch: 'feature/Xcode9-Swift4', :submodules => true
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
  pod 'RxRealm'
  pod 'KeychainAccess'

  target 'Rev FBCTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Rev FBCUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = ‘3.0’ # or '3.0'
    end
  end
end
