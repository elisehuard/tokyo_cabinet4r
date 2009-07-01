require 'rubygems'
require 'tokyocabinet'
require 'activesupport'
require 'adapter'
require 'connection'
require File.dirname(__FILE__) + '/errors'

module TokyoCabinet4r

  # TDB Table database (http://tokyocabinet.sourceforge.net/rubydoc/)
  # "Table database is a file containing records composed of the primary keys and arbitrary columns
  # and is handled with the table database API.
  # Before operations to store or retrieve records, it is necessary to open a database file and connect the table database object to it. To avoid data missing or corruption, it is important to close every database file when it is no longer in use.
  # It is forbidden for multible database objects in a process to open the same database at the same time."

  class Tdb
    include TokyoCabinet

    cattr_accessor :connection, :instance_writer => false
    @@connection = Adapter.new(TDB)
    include Connection

    attr_accessor :key, :value

    # open the db, or create it if not there yet
    def initialize(key,hash)
      @key = key
      @value = hash
      self.put(key,hash)
    end

    # get record based on key
    def self.get(key)
      open
      hash = db.get(key)
      close
      hash
    end

    # add key-values (column and content) to existing record
    def add_columns(key,value)
      open
      unless db.putcat(key,value)
        raise TCPutError
      end
      close
    end

    # completely update existing record
    def update(hash)
      key = self.key
      self.delete
      @value = hash
      put(key,hash)
    end

    # delete existing record 
    def delete
      open
      db.out(self.key)
      close
    end

    def self.delete(key)
      open
      db.out(key)
      close
    end

    # truncate existing table
    def self.truncate
      open
      db.vanish
      close
    end

    # most final: drop the entire table - delete the file
    def self.drop
      open
      File.unlink(db.path)
      close
    end
    
  protected
  
    # new record (hash contains column)
    def put(key,hash)
      open
      unless db.putkeep(key,hash)
        raise TCPutError
      end
      close
    end

  end
end
