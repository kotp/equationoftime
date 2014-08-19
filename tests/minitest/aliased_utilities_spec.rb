# aliased_utilities_spec.rb
#
# uncomment below for minitest
gem 'minitest'
require 'minitest/autorun'
# require_relative '../spec_config'
lib = File.expand_path('../../../lib', __FILE__)
# puts "Loading gem from #{lib}/eot.rb"
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eot'

Eot_aliased_utilities = EqoT.new

describe 'Eot_aliased_utilities defaults' do

  it 'expected   0.0 returned by Eot_aliased_utilities.degrees_to_radians() ' do
    assert_equal 0.0, Eot_aliased_utilities.degrees_to_radians()
    assert_equal 0.0, Eot_aliased_utilities.degrees_to_radians(nil)
    assert_equal 0.0, Eot_aliased_utilities.degrees_to_radians(0)
  end
  
  it 'expected   0.0 returned by Eot_aliased_utilities.radians_to_degrees() ' do
    assert_equal 0.0, Eot_aliased_utilities.radians_to_degrees()
    assert_equal 0.0, Eot_aliased_utilities.radians_to_degrees(nil)
    assert_equal 0.0, Eot_aliased_utilities.radians_to_degrees(0)
  end  

  it 'expected   0.0 returned by Eot_aliased_utilities.truncate() ' do
    assert_equal 0.0, Eot_aliased_utilities.truncate()
    assert_equal 0.0, Eot_aliased_utilities.truncate(nil)
    assert_equal 0.0, Eot_aliased_utilities.truncate(0)
  end    

end