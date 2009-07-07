require 'activesupport'
#require 'tokyocabinet'
module TokyoCabinet4r
  module Connection
    def self.included(base)
      base.extend(ClassMethods)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      protected
      # first time: access the table and put reference in class variable
      def open
        connection.open(self.class)
      end

      def access(&block)
        connection.access(self.class,&block)
      end

      def close
        connection.close
      end

      def connection
        self.class.connection
      end

      def db
        connection.db
      end
    end
    module ClassMethods
      protected
      def open
        connection.open(self)
      end

      def access(&block)
        connection.access(self,&block)
      end

      def close
        connection.close
      end

      def db
        connection.db
      end

      def delete_file
        connection.delete_file
      end
    end
  end
end