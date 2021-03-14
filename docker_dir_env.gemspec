
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "docker_dir_env/version"

Gem::Specification.new do |spec|
  spec.name          = "docker_dir_env"
  spec.version       = DockerDirEnv::VERSION
  spec.authors       = ["Benjamin Deutscher"]
  spec.email         = ["ben@bdeutscher.org"]

  spec.summary       = %q{This gem brings a setup of docker management script, a database.yml and .envrc file.}
  spec.description   = %q{I am using docker containers for development of a rails app as well as the environmental credentials. I figured that I'm adding the same three files to all of my projects. Since I have a bunch of existing projects a custom template is not an option. So I went with a gem and a generator instead. }
  spec.homepage      = "https://github.com/BedeDD/DockerDirEnv.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/BedeDD/DockerDirEnv.git"
    spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rails", "~> 6.0"
end
