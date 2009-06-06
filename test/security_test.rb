require File.dirname(__FILE__) + '/helper'

module SecurityFilter
  def add_one(input)
    "#{input} + 1"
  end
end

class SecurityTest < Test::Unit::TestCase
  include Liquid

  def test_no_instance_eval
    text = %( {{ '1+1' | instance_eval }} )
    expected = %! Liquid error: Error - filter 'instance_eval' in ''1+1' | instance_eval' could not be found. !
        
    assert_equal expected, Template.parse(text).render(@assigns)
  end
  
  def test_no_existing_instance_eval
    text = %( {{ '1+1' | __instance_eval__ }} )
    expected = %! Liquid error: Error - filter '__instance_eval__' in ''1+1' | __instance_eval__' could not be found. !
        
    assert_equal expected, Template.parse(text).render(@assigns)
  end
  

  def test_no_instance_eval_after_mixing_in_new_filter
    text = %( {{ '1+1' | instance_eval }} )
    expected = %! Liquid error: Error - filter 'instance_eval' in ''1+1' | instance_eval' could not be found. !
  
    assert_equal expected, Template.parse(text).render(@assigns)
  end


  def test_no_instance_eval_later_in_chain
    text = %( {{ '1+1' | add_one | instance_eval }} )
    expected = %! Liquid error: Error - filter 'instance_eval' in ''1+1' | add_one | instance_eval' could not be found. !
  
    assert_equal expected, Template.parse(text).render(@assigns, :filters => SecurityFilter)
  end
end