Pod::Spec.new do |s|
  s.name = 'ASMapLauncher'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Navigation with mapping apps in Swift'
  s.homepage = 'https://github.com/abdullahselek/ASMapLauncher'
  s.authors = { 'Abdullah Selek' => 'as@abdullahselek.com' }
  s.source = { :git => 'https://github.com/abdullahselek/ASMapLauncher.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ASMapLauncher/Source/*.swift'

  s.requires_arc = true
end