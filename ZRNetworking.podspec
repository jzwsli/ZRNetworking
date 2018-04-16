Pod::Spec.new do |s|

s.name                = "ZRNetworking"
s.version             = "1.0.0"
s.summary             = "for me"
s.homepage            = "https://github.com/jzwsli/ZRNetworking"
s.license             = { :type => "MIT", :file => "LICENSE" }
s.author             = { "lzr" => "532028798@qq.com" }
s.social_media_url   = "https://www.jianshu.com/u/d1ed5e3dbcbd"
s.platform            = :ios, "9.0"
s.source              = { :git => "https://github.com/jzwsli/ZRNetworking.git", :tag => s.version }
s.source_files        = "ZRNetworking/**/*.{h,m}"
s.resources          = "ZRNetworking/Images/*.png"
s.requires_arc        = true
s.framework  = "Foundation"
end


