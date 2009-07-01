require 'rubygems'
require 'tokyocabinet'

module TokyoCabinet4r

  class UnknownType < StandardError
  end

  class FileNotOpened < StandardError  
  end

  class Adapter  
    
    STORAGE = "#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}/"
    attr_accessor :type
    attr_accessor :db
    
    def initialize(tokyo_klas)
      raise UnknownType if tokyo_klas != TokyoCabinet::TDB && tokyo_klas != TokyoCabinet::BDB
      @type = tokyo_klas
    end

    def close
      closed = @db.close
      closed
    end

    def open(klas)
      # create database file with name = name of class in lowercase ".hdb" - and then set @@storage
      # activesupport underscore
      name = klas.to_s.underscore
      storage = STORAGE + klas.to_s.underscore + "." + @type.to_s.split('::')[-1].downcase
      @db = @type::new
      if !@db.open(storage, TokyoCabinet::TDB::OWRITER | TokyoCabinet::TDB::OCREAT)
        STDERR.printf("open error: %s\n", @db.errmsg(@db.ecode))
        raise FileNotOpened.new(@db.errmsg(@db.ecode))
      end      
    end
  end
end