require "rubygems"
require "hessian2"
require "stat-count-client"

$:.unshift File.join(File.dirname(__FILE__),"..","lib")

class Test
  include Stat::Count::Data
  def testHessian
   count = SimpleCount.new
   count = Test.new
   index =  count.class.name.rindex "::"
   index = (index.nil?) ?  0 : index+2
   puts count.class.name[index..-1]
  end
end
test = Test.new
test.testHessian