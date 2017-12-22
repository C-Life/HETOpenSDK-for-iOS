#
#  Be sure to run `pod spec lint HETPublicSDK_WiFiModule_HF_LPT100_V3.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name = "HETOpenSDK"
    s.version = "2.0.2"
    s.summary = "H&T开放平台SDK"
    s.ios.deployment_target = '8.0'
    s.homepage     = "https://github.com/C-Life/HETOpenSDK-for-iOS"
    s.license      = 'Apache License, Version 2.0'
    s.author       = { "mr.cao" => "340395573@qq.com" }
    s.source       = { :git => "https://github.com/C-Life/HETOpenSDK-for-iOS.git", :commit => "7beabd576bed3997bd3e9c14531cc6dc67bda53b"}
    s.requires_arc = true
    s.vendored_frameworks='SDK/HETOpenSDK.framework'
    s.resource = 'SDK/HETOpenSDK.bundle'
    s.library = 'z'
    s.dependency 'SSZipArchive', '1.1'


   # HETMattressDeviceSDK 睡眠带子模块
   s.subspec 'HETMattressDeviceSDK' do |sp|
   sp.vendored_frameworks = 'Optional/HETMattressDeviceSDK.framework'
   end

end


