# frozen_string_literal: true

Gem::Specification.new do |spec|
    spec.name          = "robotjoosen"
    spec.version       = "0.1.0"
    spec.authors       = ["Roald Joosen"]
    spec.email         = ["robotjoosen@gmail.com"]

    spec.summary       = "Just another website to seem legit"
    spec.homepage      = "https://github.com/robotjoosen"
    spec.license       = "MIT"

    spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|.idea)!i) }

    spec.add_runtime_dependency "jekyll", "~> 4.3"
    spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
    spec.add_runtime_dependency "jekyll-sitemap", "~> 1.4"
    spec.add_runtime_dependency "jekyll-feed", "~> 0.6"
    spec.add_runtime_dependency "kramdown-parser-gfm", "~> 1.1"
    spec.add_runtime_dependency "kramdown", "~> 2.3.2"
#     spec.add_runtime_dependency "jekyll-sass-converter", "~> 3"

    spec.add_development_dependency "bundler", "~> 2.0"
    spec.add_development_dependency "rake", "~> 12.0"
end
