require_relative "lib/hypershield/version"

Gem::Specification.new do |spec|
  spec.name          = "hypershield"
  spec.version       = Hypershield::VERSION
  spec.summary       = "Shield sensitive data in Postgres and MySQL"
  spec.homepage      = "https://github.com/ankane/hypershield"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.7"

  spec.add_dependency "activerecord", ">= 6"
end
