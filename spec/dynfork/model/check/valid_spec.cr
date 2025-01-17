require "../../../spec_helper"

describe DynFork::Model do
  describe "#valid?" do
    it "=> validation of instance of Models", tags: "valid" do
      # To generate a key (This is not an advertisement): https://randompasswordgen.com/
      unique_key = "817c0pG4gw7A4rQ4"
      database_name = "test_#{unique_key}"
      mongo_uri = "mongodb://localhost:27017"

      # Delete database before test.
      # (if the test fails)
      mongo_client = Mongo::Client.new(mongo_uri)
      Spec::Support.delete_test_db(mongo_client[database_name])
      mongo_client.close

      # Run migration.
      m = DynFork::Migration::Monitor.new(
        database_name: database_name,
      )
      m.migrat
      #
      # HELLISH BURN
      # ------------------------------------------------------------------------
      m = Spec::Data::DefaultNoNil.new
      valid = m.valid?
      m.print_err unless valid
      valid.should be_true
      #
      m = Spec::Data::ValueNoNil.new
      valid = m.valid?
      m.print_err unless valid
      valid.should be_true
      #
      FileUtils.rm_rf("public/media/uploads/files")
      FileUtils.rm_rf("public/media/uploads/images")
      # ------------------------------------------------------------------------
      #
      # Delete database after test.
      Spec::Support.delete_test_db(
        DynFork::Globals.mongo_database)
      #
      DynFork::Globals.mongo_client.close
    end
  end
end
