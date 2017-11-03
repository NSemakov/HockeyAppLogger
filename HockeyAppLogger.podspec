# coding: utf-8
Pod::Spec.new do |s|

# MARK: - Description

  s.name                  = 'HockeyAppLogger'
  s.summary               = 'HockeyAppLogger is a Swift library that send non-fatal crashes to HockeyApp'
  s.version               = '0.0.1'

  s.platform              = :ios
  s.ios.deployment_target = '8.0'
  s.static_framework      = true

  s.authors               = { 'Roxie Mobile Ltd.' => 'sales@roxiemobile.com', 'Alexander Bragin' => 'bragin-av@roxiemobile.com', 'Nikita Semakov' => 'SemakovNV@ekassir.com' }
  s.license               = { type: 'BSD-4-Clause', file: 'LICENSE.txt' }

  s.homepage              = 'https://github.com/NSemakov/HockeyAppLogger'

  s.source                = { git: 'https://github.com/NSemakov/HockeyAppLogger', tag: "v#{s.version}" }
  s.preserve_path         = 'LICENSE.txt'

  s.pod_target_xcconfig   = { 'ENABLE_BITCODE' => 'NO', 'SWIFT_VERSION' => '4.0' }

# MARK: - Modules

  s.dependency 'SwiftCommons/Core/Concurrent'
  s.dependency 'SwiftCommons/Core/Data'
  s.dependency 'SwiftCommons/Core/Extension'
  s.dependency 'ModernDesign/UI/Extensions'
  
end
