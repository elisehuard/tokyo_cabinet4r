require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'
#require 'test/unit'
gem 'thoughtbot-shoulda', ">= 2.9.0"
require 'shoulda'
require 'mocha'

ROOT       = File.join(File.dirname(__FILE__), '..')
RAILS_ROOT = ROOT
RAILS_ENV = "test"

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'tokyo_cabinet4r')

require File.join(ROOT, 'lib', 'tokyo_cabinet4r.rb')

class PhoneNumber < TokyoCabinet4r::Bdb
end

class Path < TokyoCabinet4r::Tdb 
end