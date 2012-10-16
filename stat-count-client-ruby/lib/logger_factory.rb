#encoding: UTF-8

require "logger"
require "config_loader"
require "monitor"

class LoggerFactory
    include ConfigLoader
    @@logger = nil
    def self.getLogger(name, log_path=nil, log_level=nil)
       if @@logger.nil?
         @monitor = Monitor.new
         @monitor.synchronize do
           if @@logger.nil?
             if(log_path.nil?)
               log_path = CONFIG['log.file.'+name];
               if(log_path.nil?)
                 log_path = "../log"
               end
             end

              if log_level.nil?
                log_level = CONFIG['log.level.'+name]
                if(log_level.nil?)
                  log_level = "error";
                end
              end

             logger = Logger.new(log_path,'daily')
             logger.level = Logger::const_get(log_level.upcase)
             @@logger = logger;
           end
         end
       end
       @@logger
    end
end