require 'test_helper'
#require 'fileutils'

class TokyoCabinet4rBdbTest < ActiveSupport::TestCase
  # context ensuring that database is removed after each tests, like in activerecord tests
  context "tokyo cabinet action" do
    context "storage" do
      should "create a storage file when initializing" do
        ph = PhoneNumber.new("hello","noissue")
        assert File.exists?("#{RAILS_ROOT}/db/tokyo/test/phone_number.tcb")
      end
    end

    context "key-value action" do
      setup do
        @ph = PhoneNumber.new("hello","toodeloo")
      end

      should "retrieve a value after storage" do
        PhoneNumber.new("test","test")
        assert_equal PhoneNumber.get("test"),"test"
      end

   #  not planned to use non-unique values, but anyway
   #   should "retrieve all values for a given key" do
   #     PhoneNumber.new("hello","redo")
   #     assert_equal PhoneNumber.all("hello"), ["redo",1]
   #   end

      should "delete a value" do
        @ph = PhoneNumber.new("again","test")
        assert @ph.delete
        assert_nil PhoneNumber.get("again")
      end

      should "update a value" do
        @ph = PhoneNumber.new("test","right")
        @ph.update("left")
        assert_equal PhoneNumber.get("test"),"left"
      end

    end

    should  "drop table on demand" do
      @ph = PhoneNumber.new("key","value")
      PhoneNumber.drop
      assert !File.exists?("#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}/phone_number.tcb")
    end

    # do away with created db
    teardown do
      db_file = "#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}/phone_number.tcb"
      File.unlink(db_file) if File.exists?(db_file)
    end
  end 
end
