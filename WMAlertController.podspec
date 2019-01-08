Pod::Spec.new do |s|
  s.name             = 'WMAlertController'
  s.version          = '0.3.0'
  s.summary          = 'A customizable alert controller, designed to behave like UIAlertController.'
  s.homepage         = 'https://github.com/workmarket-oss/alertcontroller'
  s.license          = { :type => 'ASLv2', :file => 'LICENSE' }
  s.author           = { 'WorkMarket' => 'andrei.tulai@gmail.com' }
  s.source           = { :git => 'https://github.com/workmarket-oss/alertcontroller.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/**/*'
end
