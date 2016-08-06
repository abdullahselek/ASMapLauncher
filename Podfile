platform :ios, '8.0'

def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'OCMock', '~> 3.3'
end

target 'ASMapLauncher' do
  	use_frameworks!

  	target 'ASMapLauncherTests' do
    	inherit! :search_paths
    	testing_pods
  	end

end
