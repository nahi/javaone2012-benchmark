if $DEBUG
  begin
    require 'simplecov'
    SimpleCov.start
  rescue LoadError
  end
end
$DEBUG = true
require "test/unit"
