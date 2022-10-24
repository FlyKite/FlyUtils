Pod::Spec.new do |s|
  s.name = 'FlyUtils'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'A utils collection for iOS projects'
  s.homepage = 'https://github.com/FlyKite/FlyUtils'
  s.authors = { 'FlyKite' => 'DogeFlyKite@gmail.com' }
  s.source = { :git => 'https://github.com/FlyKite/FlyUtils.git', :tag => s.version }

  s.ios.deployment_target = '11.0'

  s.swift_versions = ['5']

  s.source_files = 'FlyUtils/*.swift'
end
