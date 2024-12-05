Gem::Specification.new do |s|
  s.name = "ianfleeton-paypal-express"
  s.version = File.read(File.join(File.dirname(__FILE__), "VERSION"))
  s.licenses = ['MIT']
  s.required_ruby_version = '>= 3.1.0'
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian Fleeton", "nov matake"]
  s.description = %q{PayPal Express Checkout API Client for Instance, Recurring and Digital Goods Payment.}
  s.summary = %q{PayPal Express Checkout API Client for Instance, Recurring and Digital Goods Payment.}
  s.email = 'ianfleeton@gmail.com'
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/ianfleeton/paypal-express"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.add_dependency 'activesupport', '>= 7.0', '< 9'
  s.add_dependency 'rest-client', '~> 2.0'
  s.add_dependency 'attr_required', '~> 1.0'
  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.0'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'rspec', '~> 3.13', '>= 3.13.0'
  s.add_development_dependency 'webmock', '~> 3.18', '>= 3.18.1'
end
