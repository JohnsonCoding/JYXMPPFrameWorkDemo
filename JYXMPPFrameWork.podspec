
Pod::Spec.new do |spec|

  spec.name         = "JYXMPPFrameWork"
  spec.version      = "0.0.1"
  spec.summary      = "后台openfire搭建服务,iOS端XMPPFramework实现客服聊天功能,MessageKit搭建聊天界面UI"
  spec.homepage     = "https://github.com/JohnsonCoding/JYXMPPFrameWorkDemo"
  spec.license      = "MIT"
  spec.author       = { "JohnsonCode" => "jiangyong0708@163.com" }
  spec.source       = { :git => "https://github.com/JohnsonCoding/JYXMPPFrameWorkDemo.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
  spec.requires_arc = true
end
