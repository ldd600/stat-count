#encoding: UTF-8

$:.unshift File.join(File.dirname(__FILE__),"..","lib")
$:.unshift File.join(File.dirname(__FILE__),"..")

require "rubygems"
require "hessian2"
require "stat-count-client"
require_relative  "count_mother"
require "test/unit"

class TC_StatCountClientTest < Test::Unit::TestCase
  include Stat::Count::Client
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @client = StatCountClient.new({'hessian.domain'=>'http://localhost:8080/stat-count-runtime/hessian/remoteSimpleCountCollecter', 'log.file.StatCountClient'=>'D:/log/stat/stat-count-ruby.log'});
    puts @client
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  #def test_incr
  #  @client.set("testDay", "1", 1)
  #  value = @client.incr("testDay", "1", 2)
  #  assert_equal(3, value)
  #end
  #
  #def test_incrByCount
  #  reset()
  #  count = CountMother.createIncrCount
  #  countResult = @client.incrByCount(count)
  #  puts countResult.getResult()
  #  assertCorrect(countResult)
  #end
  #
  #def test_incrByCountWithDate
  #  resetWithDate()
  #  dateCount = CountMother.createIncrCountWithDate
  #  @client.incrByCountWithDate(dateCount)
  #  dateQuery = CountMother.createCountQueryWithDate
  #  countResult = @client.getByQuery(dateQuery)
  #  assertIncrCorrectWithDate(countResult)
  #end

  def testDecr
    #@client.set("user.tracks.count", "1", 0)
    #begin
    # val = @client.decr("user.tracks.count", "1", 7)
    # assert_equal(0,val)
    #rescue => err
    #  puts err
    #end
    #
    #getVal = @client.get("user.tracks.count", "1")
    #assert_equal(0,getVal)

    puts @client.getHello()
    puts @client.getHello1()
  end

  #def testDecrByCount
  #  count = CountMother.initCount
  #  @client.setByCount(count)
  #  count = CountMother.createDecrCount
  #  countResult = @client.decrByCount(count)
  #  assertDecrCorrect(countResult)
  #  reset()
  #end
  #
  #def test_set
  #  @client.reset("test", "1")
  #  @client.set("test", "1", 100000000000000000)
  #  val = @client.get("test", "1");
  #  assert_equal(100000000000000000, val)
  #end
  #
  #def test_setByCount
  #  reset()
  #  count = CountMother.initCount
  #  @client.setByCount(count)
  #  query = CountMother.createCountQuery();
  #  countResult = @client.getByQuery(query)
  #   assertInitCorrect(countResult)
  #end
  #
  #def test_del
  #    count = CountMother.initCount
  #    @client.setByCount(count)
  #    query = CountMother.createCountQuery()
  #    @client.delByQuery(query)
  #    countResult = @client.getByQuery(query)
  #    assertDel(countResult)
  #end
  #
  #private
  #def resetWithDate
  #  1.upto(5) do |i|
  #    @client.reset("testHour", i.to_s, 10)
  #  end
  #
  #  1.upto(5) do |i|
  #    @client.reset "testDay", i.to_s, 10
  #  end
  #end
  #
  #def reset
  #  @client.reset("test", "1")
  #  @client.reset("testHour", "2")
  #  @client.reset("testDay", "3")
  #end

  def assertCorrect(countResult)
    count = countResult.getResult("test", "1")
    assert_equal(3, count)

    count = countResult.getResult("testHour", "2")
    assert_equal(4, count)

    count = countResult.getResult("testDay", "3")
    assert_equal(8, count)
  end

  def assertIncrCorrectWithDate(countResult)
    resultMap = countResult.getResult("testHour")

    resultMap.each { |key, value|
        id_val = key.to_i
        assert_equal(id_val * 10, value)
    }

    resultMap = countResult.getResult("testDay");

    resultMap.each { |key, value|
       id_val = key.to_i
       assert_equal(id_val * 10, value)
    }
  end

   def assertDecrCorrectWithDate(countResult)
     resultMap = countResult.getResult("testHour")
     resultMap.each { |key, value|
       id_val = new Integer(key)
       assert_equal(id_val * 10 - 10, value)
     }

     resultMap = countResult.getResult("testDay")
     resultMap.each {  |key, value|
        id_val = new Integer(key)
       assert_equal(id_val * 10 - 10 ,value)
     }
   end

   def assertDecrCorrect(countResult)
     count = countResult.getResult("test", "1")
     assert_equal(1, count)

     count = countResult.getResult("testHour", "2")
     assert_equal(2, count)

     count = countResult.getResult("testDay", "3")
     assert_equal(3, count)
   end

   def assertInitCorrect(countResult)
     count = countResult.getResult("test", "1")
     assert_equal(10, count)

     count = countResult.getResult("testHour", "2")
     assert_equal(10, count)

     count = countResult.getResult("testDay", "3")
     assert_equal(10, count);
   end

  def assertDel(countResult)
    count = countResult.getResult("test", "1")
    assert_equal(0, count)

    count = countResult.getResult("testHour", "2")
    assert_equal(0, count)

    count = countResult.getResult("testDay", "3")
    assert_equal(0, count);
  end
end