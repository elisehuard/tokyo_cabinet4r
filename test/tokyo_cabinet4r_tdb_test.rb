require File.dirname(__FILE__) + '/test_helper'

class TokyoCabinet4rTdbTest < ActiveSupport::TestCase
  # context ensuring that database is removed after each tests, like in activerecord tests
  context "tokyo cabinet action" do
    context "storage" do
      should "create a storage file when creating a record the first time" do
        ph = Path.new("route",{"1"=> "2", "2"=> "3"})
        assert File.exists?("#{RAILS_ROOT}/db/tokyo/test/path.tct")
      end
    end

    context "key-value action" do
      setup do
        @p = Path.new("route",{"1"=> "2", "2"=> "3"})
      end

      should "store a key-value" do
        assert_not_nil @p
      end

      should "retrieve a value after storage" do
        Path.new("test",{"1"=> "2", "2"=> "3"})
        assert_equal Path.get("test"),{"1"=> "2", "2"=> "3"}
      end

      should "delete a value from instance" do
        @ph = Path.new("again",{"1"=> "2", "2"=> "3"})
        assert @ph.delete
        assert_nil Path.get("again")
      end

      should "add a field to a record" do
        @ph = Path.new("test",{"1" => "3"})
        @ph.add_data("3","5")
        assert_equal Path.get("test"),{"1" => "3","3" => "5"}
      end

      should "delete a value from class" do
        @ph = Path.new("again",{"1"=> "2", "2"=> "3"})
        assert Path.delete("again")
        assert_nil Path.get("again")
      end

      should "update a value" do
        @p = Path.new("test",{"1"=> "2", "2"=> "3"})
        @p.update({"1"=> "2", "2"=> "4"})
        assert_equal Path.get("test"),{"1"=> "2", "2"=> "4"}
      end

    end

    should  "drop table on demand" do
      Path.new("test",{"1"=> "2", "2"=> "3"})
      Path.drop
      assert !File.exists?("#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}/path.tct")
    end

    # do away with created db
    teardown do
      db_file = "#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}/path.tct"
      File.unlink(db_file) if File.exists?(db_file)
    end
  end
end