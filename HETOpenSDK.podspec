#
#  Be sure to run `pod spec lint HETPublicSDK_WiFiModule_HF_LPT100_V3.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name = "HETOpenSDK"
    s.version = "2.0.9"
    s.summary = "H&T开放平台SDK"
    s.ios.deployment_target = '8.0'
    s.homepage     = "https://github.com/C-Life/HETOpenSDK-for-iOS"
    s.license      = 'Apache License, Version 2.0'
    s.author       = { "mr.cao" => "340395573@qq.com" }
    s.source       = { :git => "https://github.com/C-Life/HETOpenSDK-for-iOS.git", :commit => "46d69924274113c196fa998b805db99654361332"}
    s.requires_arc = true
    s.default_subspecs = 'HETOpenSDK'

    # 核心模块
    s.subspec 'HETOpenSDK' do |sp|
    sp.vendored_frameworks='SDK/HETOpenSDK.framework'
    sp.resource = 'SDK/HETOpenSDK.bundle'
    sp.library = 'z'
    sp.dependency 'SSZipArchive', '1.1'
    end

   # HETMattressDeviceSDK 睡眠带子模块
   s.subspec 'HETMattressDeviceSDK' do |sp|
   sp.vendored_frameworks = 'Optional/HETMattressDeviceSDK.framework'
   end

end


