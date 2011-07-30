require File.dirname(__FILE__) + '/test_helper.rb'

class TestScbiAce < Test::Unit::TestCase

  def setup
  end
  
  def test_open
    ace=IndexedAceFile.new(File.join(File.dirname(__FILE__),'test.ace'))

    puts ace.read_contig('7180000000028')[0..100]
    puts ace.read_contig('7180000000029')

    ace.close
    assert true
  end
  
  
end
