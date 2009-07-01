require 'activesupport'
require 'tokyocabinet'
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

      def open
        connection.open(self)
      end

      def close
        connection.close
      end
      #
      #def connection
      #  @@connection
      #end

      def db
        connection.db
      end
    end
  end
end