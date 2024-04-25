require "../../../spec_helper"

describe DynFork::Model do
  describe "#valid?" do
    it "=> validation of instance of Models", tags: "valid" do
      # Init data for test.
      #
      # To generate a key (This is not an advertisement): https://randompasswordgen.com/
      unique_app_key = "817c0pG4gw7A4rQ4"
      database_name = "test_#{unique_app_key}"
      mongo_uri = "mongodb://localhost:27017"

      # Delete database before test.
      # (if the test fails)
      Spec::Support.delete_test_db(
        Mongo::Client.new(mongo_uri)[database_name])

      # Run migration.
      DynFork::Migration::Monitor.new(
        "app_name": "AppName",
        "unique_app_key": unique_app_key,
        "database_name": database_name,
        "mongo_uri": mongo_uri,
      ).migrat
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
      FileUtils.rm_rf("assets/media/files")
      FileUtils.rm_rf("assets/media/images")
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
