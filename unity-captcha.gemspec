# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unity/captcha/version'

Gem::Specification.new do |spec|
  spec.name          = "unity-captcha"
  spec.version       = Unity::Captcha::VERSION
  spec.authors       = ["Manuel Fernandez"]
  spec.email         = ["papayalabs@gmail.com"]

  spec.summary       = %q{Unity Captcha is a gem that use two levels of captcha based on the hemispheres of the brain}
  spec.description   = %q{Unity Captcha is a gem that use two levels of Captcha. First level is about Left Hemisphere: Logic and Math. Second level is about Right Hemisphere: Intuition and Drawing. This two levels functioning in complete harmony creates unity and this is the base design of this Captcha.}
  spec.homepage      = "https://github.com/papayalabs/unity-captcha"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
