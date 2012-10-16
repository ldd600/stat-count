#encoding: UTF-8

module Hessian
   module Data
       module Utils
         def to_hash_unit
           hash = {}
           instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
           hash
         end

         def to_hash_map
           hash = {}
           instance_variables.each {|var|
             internal_hash = {}
             map = instance_variable_get(var)
             map.each { |key, list|
               newList = nil
               list.each { |unit|
                 if (newList.nil?)
                   newList = Array.new
                 end
                 newList << unit.to_hessian
               }
               internal_hash[key] = newList
             }
             hash[var.to_s.delete("@")] = internal_hash
           }
           hash
         end

         def java_class_name(java_package)
           index =  self.class.name.rindex "::"
           index = (index.nil?) ?  0 : index+2
           simple_name = self.class.name[index..-1]
           java_package.nil? ? simple_name : java_package + "." + simple_name
         end
       end
  end
end