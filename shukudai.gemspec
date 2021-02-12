# frozen_string_literal: true

require_relative "lib/shukudai/version"

Gem::Specification.new do |spec|
  spec.name          = "shukudai"
  spec.version       = Shukudai::VERSION
  spec.authors       = ["Ingo Becker"]
  spec.email         = ["ingo@orgizm.net"]

  spec.summary       = "Japanese language learning tool"
  spec.description   = <<~DESC
    Tool for creating randomized worksheets of different kinds.
  DESC
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["source_code_uri"] = "https://github.com/ingobecker/shukudai"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob(["lib/**/*", "data/*"])
  end
  spec.bindir        = "exe"
  spec.executables   = %w[shukudai]
  spec.require_paths = ["lib"]
  spec.add_dependency "eiwa"
  spec.add_dependency "prawn", "~> 2"
  spec.add_dependency "prawn-svg", "~> 0.31.0"
end
