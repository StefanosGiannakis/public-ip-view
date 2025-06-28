#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
#
Pod::Spec.new do |s|
  s.name             = 'home_widget'
  s.version          = '0.3.0'
  s.summary          = 'A Flutter plugin to use Android Home Screen Widgets and iOS Home Screen Quick Actions.'
  s.description      = <<-DESC
A Flutter plugin to use Android Home Screen Widgets and iOS Home Screen Quick Actions.
                       DESC
  s.homepage         = 'https://github.com/ABausG/home_widget'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Anton Borries' => 'mail@antonborri.es' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end