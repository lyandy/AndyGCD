Pod::Spec.new do |s|
  s.name         = "AndyGCD"
  s.version      = "1.1.0"
  s.summary      = "AndyGCD aimed to make C GCD easier and simpler to use. "

  s.description  = "AndyGCD aimed to make C GCD、OC Thread easier and simpler to use. Include dispatchQueue、delay、group、timer、semaphore、apply、barrier、LifeFreedomThread and SafeThread"

  s.homepage     = "https://github.com/lyandy/AndyGCD"
  s.license      = "MIT"
  s.author       = { "李扬" => "liyangforever@vip.qq.com" }
  s.source       = { :git => "https://github.com/lyandy/AndyGCD.git", :tag => s.version }

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.public_header_files = 'AndyGCD/**/*.{h}'
  s.source_files = 'AndyGCD/**/*.{h,m}'

  s.framework  = "Foundation"
  s.requires_arc = true
end
