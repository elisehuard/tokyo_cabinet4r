require 'rubygems'
require 'rufus/tokyo'
require 'errors'

module TokyoCabinet4r

  class CabinetAdapter  

    STORAGE = "#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}/"
    EXTENSIONS = {:btree => '.tcb',:hash => ".tch", :fixed => ".tcf"}
    attr_accessor :type
    attr_accessor :db
    attr_accessor :path

    def initialize(type)
      raise UnknownType if type != :btree && type != :hash && type != :fixed
      @type = type
    end

    def close
      closed = @db.close
      closed
    end

    def open(klas)
      # create database file with name = name of class in lowercase ".hdb" - and then set @@storage
      # activesupport underscore
      name = STORAGE + klas.to_s.underscore
      @path = name + EXTENSIONS[@type]
      @db = Rufus::Tokyo::Cabinet.new(name,:type => @type)
    end  

    def delete_file
      File.unlink(@path)
    end
  end
end