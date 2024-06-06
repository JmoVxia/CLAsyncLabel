Pod::Spec.new do |s|

  s.name         = 'CLAsyncLabel'
  s.version      = '1.0.0'
  s.summary      = 'Swift版异步绘制Label'
  s.description  = <<-DESC
                   CLAsyncLabel 是一个用于 iOS 的 Swift 异步绘制文本的库。它提供了高效的文本渲染方法，避免了主线程阻塞，提高了应用的流畅度和响应速度。
                   DESC
  s.homepage     = 'https://github.com/JmoVxia/CLAsyncLabel'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = {'JmoVxia' => 'JmoVxia@gmail.com'}
  s.social_media_url = 'https://github.com/JmoVxia'
  s.swift_versions = ['5.0']
  s.ios.deployment_target = '12.0'
  s.source       = {:git => 'https://github.com/JmoVxia/CLAsyncLabel.git', :tag => s.version}
  s.source_files = ['AsyncLabel/**/*.swift']
  s.requires_arc = true

end