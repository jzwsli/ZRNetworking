Pod::Spec.new do |s|

s.name                = "ZRNetworking"
s.version             = "1.0.0"
s.summary             = "integrate APNs rapidly"
s.homepage            = "https://github.com/jzwsli/ZRNetworking"
s.license             = { :type => "MIT", :file => "LICENSE" }
s.author             = { "lzr" => "532028798@qq.com.com" }
s.social_media_url   = "http://lzr.cn"
s.platform            = :ios, "9.0"
s.source              = { :git => "https://github.com/jzwsli/ZRNetworking.git", :tag => s.version }
s.source_files        = "ZRNetworking/**/*.{h,m}"
s.resources          = "ZRNetworking/Images/*.png"
s.dependency          "BPushSDK", "1.4.1"
s.requires_arc        = true

end


