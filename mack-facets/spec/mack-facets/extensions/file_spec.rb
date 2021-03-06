require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe File do
  
  describe 'join' do
    
    it 'should work like it used to' do
      File.join('a', 'b', 'c').should == 'a/b/c'
    end
    
    it 'should work with an arrary' do
      File.join(['a', 'b', 'c']).should == 'a/b/c'
    end
    
    it 'should work with a nested array' do
      File.join('a', 'b', ['c', 'cc', 'ccc']).should == 'a/b/c/cc/ccc'
    end
    
    it 'should work with non-strings' do
      File.join(:a, 1, true).should == 'a/1/true'
    end
    
  end
  
  describe 'join_from_here' do
    
    it 'should build a full expanded path from the current file location' do
      File.join_from_here('..', 'foo.rb').should == File.expand_path(File.join(File.dirname(__FILE__), '..', 'foo.rb'))
    end
    
  end
  
end