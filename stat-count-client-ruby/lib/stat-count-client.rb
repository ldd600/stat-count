#encoding: UTF-8

require "stat-count-client/version"
require "yaml"
require "config_loader"
require "logger_factory"
require "singleton"
require "hessian_data_utils"


module Stat
  module Count
    module Data
      class QueryUnit
        include Hessian::Data::Utils
        include ConfigLoader

        attr :id, true
        attr :limit, true

        def to_hash
            to_hash_unit
        end

        def to_hessian
          Hessian2::TypeWrapper.new(java_class_name("com.ximalaya.stat.count.data"), to_hash)
        end
      end

      class CountUnit
        include Hessian::Data::Utils
        include ConfigLoader

        attr :id, true
        attr :count, true

        def to_hash
            to_hash_unit
        end

        def to_hessian
          Hessian2::TypeWrapper.new(java_class_name("com.ximalaya.stat.count.data"), to_hash)
        end
      end

      class DateQueryUnit < QueryUnit
        attr :fromDate, true
        attr :toDate, true
      end

      class DateCountUnit < CountUnit
        attr :date, true

        def to_hessian
          Hessian2::TypeWrapper.new(java_class_name("com.ximalaya.stat.count.data"), to_hash)
        end
      end

      class SimpleCount
        include Hessian::Data::Utils
        include ConfigLoader

        attr_accessor :counts

        def initialize
          @counts = Hash.new
        end

        def addCount(name, id, count=1, countUnit=nil)
          countUnitList = @counts[name]
          if (countUnitList.nil?)
            countUnitList = Array.new
            @counts[name] = countUnitList
          end

          if (countUnit.nil?)
            countUnit = CountUnit.new
          end
          countUnit.id = id
          countUnit.count = count
          countUnitList << countUnit
          self
        end

        def getCounts
          @counts
        end

        def getCountsSize
          @counts.length
        end

        def to_hash
          to_hash_map
        end

        def to_hessian
            Hessian2::TypeWrapper.new(java_class_name("com.ximalaya.stat.count.data"), to_hash)
        end
      end

      class DateCount < SimpleCount
        def addCountWithDate(name, id, count=1, date=Time.now)
          dateCountUnit = DateCountUnit.new
          dateCountUnit.date = date
          addCount(name, id, count, dateCountUnit)
          self
        end

        def to_hessian
          Hessian2::TypeWrapper.new(java_class_name("com.ximalaya.stat.count.data"), to_hash)
        end
      end

      class SimpleCountQuery
        include Hessian::Data::Utils
        include ConfigLoader

        attr_accessor :queries

        def initialize
          @queries = Hash.new
        end

        def addQuery(name, id, limit=1, queryUnit=nil)
          queryUnitList = @queries[name]

          if(queryUnitList.nil?)
            queryUnitList = Array.new
            @queries[name] = queryUnitList
          end

          if(queryUnit.nil?)
            queryUnit = QueryUnit.new
          end

          queryUnit.id = id
          queryUnit.limit = limit
          queryUnitList << queryUnit
          self
        end

        def getQueries
          @queries
        end

        def to_hash
            to_hash_map
        end

        def to_hessian
          Hessian2::TypeWrapper.new(java_class_name("com.ximalaya.stat.count.data"), to_hash)
        end
      end

      class DateCountQuery < SimpleCountQuery
        def addQueryWithDate(name, id, fromDate, toDate, limit=1)
          queryUnit = DateQueryUnit.new
          addQuery(name, id, limit, queryUnit)
          self
        end

        def to_hessian
          Hessian2::TypeWrapper.new(java_class_name("com.ximalaya.stat.count.data"), to_hash)
        end
      end

      class CountResult
        attr_accessor :countResults

        def initialize(hash)
          @countResults = hash['countResults']
        end

        def getResult(name=nil, id=nil)
          if(name.nil?)
             return @countResults
          end

          countHash = @countResults[name]
          if(countHash.nil?)
            raise ArgumentError,"服务的名称: " + name + " 不存在!"
          end

          if (id.nil?)
            return countHash
          end

          count = countHash[id]
          if(count.nil?)
            railse ArgumentError,"业务ID: "+id +" 不存在"
          end
          count
        end
      end

  end

  module Client
    class StatCountClient
      include Stat::Count::Data
      include ConfigLoader

      def initialize(config={})
        @hessian_url = config['hessian.domain'];
        if (@hessian_url.nil?)
          @hessian_url ||= ENV['stat.count.domain']
          @hessian_url ||= CONFIG['hessian.domain']
        end
        @logger = LoggerFactory.getLogger("StatCountClient", config['log.file.StatCountClient'], config['log.level.StatCountClient'])

        init(@hessian_url)
      end

      def incrByCountWithDate(dateCount)
        wrapper = dateCount.to_hessian
        @client.incrByCountWithDate(wrapper)
      end

      def incrByCount(count)
         wrapper = count.to_hessian
         countResult = @client.incrByCount(wrapper)
         CountResult.new(countResult)
      end

      def incr(name, id, count=1, date=nil)
        if(date.nil?)
          @client.incrBy(name,id, count)
        else
          @client.incrByWithDate(name, id, count, date)
        end
      end

      def decr(name, id, count=1, date=nil)
         if(date.nil?)
           @client.decrBy(name, id, count)
         else
           @client.decrByWithDate(name, id, count, date)
         end
      end

      def decrByCount(count)
        wrapper = count.to_hessian
        count_result = @client.decrByCount(wrapper)
        CountResult.new(count_result)
      end

      def decrByCountWithDate(dateCount)
        wrapper = dateCount.to_hessian
        @client.decrByCountWithDate(wrapper)
      end

      def setByCountWithDate(dateCount)
        wrapper = dateCount.to_hessian
        @client.setByCountWithDate(wrapper)
      end

      def setByCount(count)
        wrapper = count.to_hessian
        @client.setByCount(wrapper)
      end

      def  set(name,id, value, date=nil)
        if(date.nil?)
          @client.set(name, id, value)
        else
          @client.setWithDate(name,id, value,date)
        end
      end

      def reset(name, id, limit=1)
        @client.resetByLimit(name, id, limit)
      end

      def get(name, id, limit=1)
        @client.getByLimit(name, id, limit)
      end

      def getByNames(name, id, limit=1)
        @client.getByNamesAndLimit(name, id, limit)
      end

      def getByIds(name, ids, limit=1)
        @client.getByIdsAndLimit(name, ids, limit)
      end

      def getByQuery(query)
        wrapper = query.to_hessian
        countResult = @client.getByQuery(wrapper)
        CountResult.new(countResult)
    end

    def getByDateQuery(dateQuery)
       wrapper = dateQuery.to_hessian
       countResult = @client.getByDateQuery(wrapper)
       CountResult.new(countResult)
    end

      def delByQuery(query)
       wrapper = query.to_hessian
       @client.delByQuery(wrapper)
      end

      def delByDateQuery(dateQuery)
        wrapper = dateQuery.to_hessian
        @client.delByDateQuery(wrapper)
      end

      def getHello
        @client.getHello()
      end

      def getHello1
        @client.getHello1()
      end

      private
      def init(hessian_url)
        if(hessian_url.nil?)
          raise ArgumentError.new("hessian url is null or empty")
        end

        @logger.info("Init Stat count client connect to hessian url: #{hessian_url}")
        begin
          @client = Hessian2::HessianClient.new(@hessian_url)
        rescue => err
          @logger.error("init hessian service fails!", err)
          raise err
        end
      end

    end
  end
end
end
