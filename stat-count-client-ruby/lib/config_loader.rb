#encoding: UTF-8

#Example
#stat.count:
#  hessian.domain: http://localhost:8080/stat-count-runtime/hessian/remoteSimpleCountCollecter
#  hessian.java.package:  com.ximalaya.stat.count.data
#  log.file: D:/log/stat/stat-count-ruby.log
#  log.level: info

module ConfigLoader
  begin
    LOADER = YAML.load_file("../config/stat-count-client.yaml");
    CONFIG = LOADER['stat.count']
  rescue => err
      CONFIG = {}
      puts "can't load config file stat-count-client.yaml, you need to init statcountclient with config hash"
  end
end