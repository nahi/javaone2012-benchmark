if $DEBUG
  begin
    require 'simplecov'
    SimpleCov.start
  rescue LoadError
  end
end
require "test/unit"
