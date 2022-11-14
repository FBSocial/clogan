#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint logan_ffi.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'logan_ffi'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Framework/include/*.h','Classes/**/*'
  s.public_header_files = 'Framework/include/*.h','Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.static_framework = true
  s.libraries = 'c++', 'z', 'sqlite3.0'
  # Flutter.framework does not contain a i386 slice.
#   s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }



  s.vendored_libraries  = 'Framework/**/*.a'

  s.pod_target_xcconfig = {
      'DEFINES_MODULE' => 'YES',
      'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }

#   s.user_target_xcconfig = {
#       'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64',
#       'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'armv7'
#    }
end
