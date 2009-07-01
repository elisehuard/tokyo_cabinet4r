require 'rubygems'
require 'tokyocabinet'
require 'activesupport'
require 'adapter'
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
    include TokyoCabinet

    cattr_accessor :connection, :instance_writer => false
    @@connection = Adapter.new(BDB)
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
      value = db.get(key)
      close
      value
    end

# ponder interface for duplicate keys
#    def self.all(key)
#      open
#      result = []
#      cur = BDBCUR::new(db)
#      cur.first
#      while key = cur.key
#        value = cur.val
#        result << value unless value.nil?
#        cur.next
#      end
#      close
#      result
#    end

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
      result = db.out(self.key)
      close
      result
    end

    # delete an instance from the class.  Returns true if successful
    def self.delete(key)
      open
      result = db.out(key)
      close
      result
    end

    # drop the entire table - delete the file
    def self.drop
      open
      File.unlink(db.path)
      close
    end
  protected
    # returns false if unsuccessful
    def put(key,value)
      open
      unless db.put(key,value)
        STDERR.printf("put error: %s\n", db.errmsg(db.ecode))
        raise TCPutError.new(db.errmsg(db.ecode))
      end
      close
    end

  end
end 

