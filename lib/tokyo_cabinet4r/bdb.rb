require 'rubygems'
require 'activesupport'
require 'cabinet_adapter'
require 'connection'
require 'errors'

module TokyoCabinet4r

  # BDB Class (http://tokyocabinet.sourceforge.net/rubydoc/)
  # "B+ tree database is a file containing a B+ tree and is handled with the B+ tree database API.
  # Before operations to store or retrieve records, it is necessary to open a database file
  # and connect the B+ tree database object to it. To avoid data missing or corruption,
  # it is important to close every database file when it is no longer in use.
  # It is forbidden for multible database objects in a process to open the same database at the same time."

  class Bdb
    #include TokyoCabinet

    cattr_accessor :connection, :instance_writer => false
    @@connection = CabinetAdapter.new(:btree)
    include Connection

    attr_accessor :key, :value
    
    # create an instance of the class
    def initialize(key,value)
      @key = key
      @value = value
      self.put(key,value)
    end

    # get record based on key
    def self.get(key)
      open
      returning db[key] do |result|
        close
      end 
    end

    # completely update existing record
    # raises error if not found
    # returns true if success, false if not
    def update(value)
      key = self.key
      raise TCKeyNotFound unless self.delete
      @value = value
      put(key,value)
    end

    # delete an instance.  Returns true if successful.
    def delete
      open
      returning db.delete(self.key) do |result|
        close
      end
    end

    # delete an instance from the class
    def self.delete(key)
      open
      returning db.delete(key) do |result|
        close
      end 
    end

    # drop the entire table - delete the file
    def self.drop
      open
      delete_file  # !!! TODO this is also abstracted away to adapter
      close
    end
  protected
    # returns true if successful
    def put(key,value)
      open
      db[key] = value
      close 
    end

  end
end 

