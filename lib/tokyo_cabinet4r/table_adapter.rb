require 'rubygems'
require 'rufus/tokyo'
require 'errors'

module TokyoCabinet4r

  class TableAdapter  
    
    STORAGE = "#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}/"
    attr_accessor :db

    def close
      @db.close
    end

    def open(klas)
      @db = Rufus::Tokyo::Table.new(path_name(klas))
    end

    def access(klas,&block)
      Rufus::Tokyo::Cabinet.new(path_name(klas)) do |db|
        yield db
      end
    end

    def delete_file
      File.unlink(@db.path)
    end
    
    private
    def path_name(klas)
      STORAGE + klas.to_s.underscore + ".tct"
    end
  end
end