Pod::Spec.new do |s|

    s.name                  = 'ASMapLauncher'
    s.version               = '1.0.8'
    s.summary               = 'ASMapLauncher is a library for iOS written in Swift that helps navigation with various mapping applications'
    s.homepage              = 'https://github.com/abdullahselek/ASMapLauncher'
    s.license               = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.author                = {
        'Abdullah Selek' => 'abdullahselek@yahoo.com'
    }
    s.source                = {
        :git => 'https://github.com/abdullahselek/ASMapLauncher.git',
        :tag => s.version.to_s
    }
    s.ios.deployment_target = '11.0'
    s.source_files          = 'ASMapLauncher/Source/*.swift'
    s.requires_arc          = true
    s.swift_version         = '5.0'

end
