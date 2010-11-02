# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{carrot}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sloan Wu"]
  s.date = %q{2010-11-02}
  s.description = %q{Carrot can make QA test easy with any integration test gem.}
  s.email = %q{sloanwu@gmail.com}
  s.extra_rdoc_files = ["lib/carrot.rb", "lib/carrot/extend_server.rb", "lib/carrot/rails.rb", "lib/carrot/server.rb", "lib/carrot/util/timeout.rb"]
  s.files = ["Manifest", "Rakefile", "carrot.gemspec", "lib/carrot.rb", "lib/carrot/extend_server.rb", "lib/carrot/rails.rb", "lib/carrot/server.rb", "lib/carrot/util/timeout.rb"]
  s.homepage = %q{http://github.com/sloanwu/carrot.git}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Carrot", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{carrot}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Carrot can make QA test easy with any integration test gem.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
