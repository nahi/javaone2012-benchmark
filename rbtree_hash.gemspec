require 'rubygems'
Gem::Specification.new { |s|
  s.name = "rbtree_hash"
  s.version = "0.0.0"
  s.date = "2012-03-16"
  s.author = "Hiroshi Nakamura"
  s.email = "nahi@ruby-lang.org"
  s.homepage = "https://github.com/koichiro/javaone2012-benchmark"
  s.platform = Gem::Platform::RUBY
  s.summary = "Hash with Red-black tree"
  s.files = Dir.glob('{lib,test}/**/*') + ['README']
  s.require_path = "lib"
}
