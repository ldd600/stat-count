#encoding: UTF-8

require "rubygems"
require "stat-count-client"

class CountMother
  include Stat::Count::Data

  def self.createIncrCount
     SimpleCount.new.addCount("test", "1", 1).addCount("test", "1", 2).addCount("testHour", "2", 4).addCount("testDay", "3", 8)
  end

  def self.createIncrCountWithDate
    dateCount = DateCount.new
    now = Time.new

    1.upto(5) do |j|
       0.upto(9) do |i|
         now_second = Time.now.to_i
         time = now - 60* 60 * i
         dateCount.addCountWithDate("testHour", j.to_s, j, time)
       end
    end

    1.upto(5) do |j|
      0.upto(9) do |i|
        now_second = Time.now.to_i
        time = now - 86400 * i
        dateCount.addCountWithDate("testDay", j.to_s, j, time);
      end
    end

    dateCount
  end

  def self.createDecrCountWithDate
     dateCount = DateCount.new
     now = Time.new

    1.upto(5)  do |j|
      0.upto(9) do |i|
        count.addCount("testHour", j.to_s, 1, Time.now - i.day)
      end
    end

     1.upto(5) do |j|
       0.upto(9) do |i|
         count.addCount("testDay", j.to_s, j, Time.now - i.day);
       end
     end
  end

  def self.initCount
    SimpleCount.new.addCount("test", "1", 10).addCount("test", "1", 10).addCount("testHour", "2", 10).addCount("testDay", "3", 10)
  end

   def self.createDecrCount
     SimpleCount.new.addCount("test", "1", 4).addCount("test", "1", 5).addCount("testHour", "2", 8).addCount("testDay", "3", 7)
   end

  def  self.createCountQuery
    SimpleCountQuery.new.addQuery("test", "1").addQuery("testHour", "2").addQuery("testDay", "3")
  end

  def self.createCountQueryWithDate
    countQuery = SimpleCountQuery.new

    1.upto(5) do |i|
      countQuery.addQuery("testHour", i.to_s, 10)
    end

    1.upto(5) do |i|
      countQuery.addQuery "testDay", i.to_s, 10
    end

    countQuery
  end


end