require "../../../spec_helper"

describe DynFork::Model do
  describe "#check" do
    it "=> validation of instance of `FullDefaultAndRequired` model", tags: "check_required" do
      # Init data for test.
      #
      # To generate a key (This is not an advertisement): https://randompasswordgen.com/
      unique_app_key = "05Q81l90S1w5SQ9f"
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
      m = Spec::Data::FullDefaultAndRequired.new
      #
      # Get the collection for the current model.
      collection : Mongo::Collection = DynFork::Globals.mongo_database[
        Spec::Data::FullDefaultAndRequired.meta[:collection_name]]
      #
      output_data : DynFork::Globals::OutputData = m.check(pointerof(collection))
      (print "(!!!-normally-!!!)".colorize.fore(:cyan).mode(:bold)
      m.print_err) unless output_data.valid?
      data : Hash(String, DynFork::Globals::ResultMapType) = output_data.data
      data.empty?.should be_true
      #
      # Param `value`
      m.url.value?.should be_nil
      m.text.value?.should be_nil
      m.phone.value?.should be_nil
      m.password.value?.should be_nil
      m.ip.value?.should be_nil
      m.hash2.value?.should be_nil
      m.email.value?.should be_nil
      m.color.value?.should be_nil
      m.slug.value?.should eq(m.hash.value?)
      #
      m.date.value?.should be_nil
      m.datetime.value?.should be_nil
      #
      m.choice_text.value?.should be_nil
      m.choice_text_mult.value?.should be_nil
      m.choice_text_dyn.value?.should be_nil
      m.choice_text_mult_dyn.value?.should be_nil
      #
      m.choice_i64.value?.should be_nil
      m.choice_i64_mult.value?.should be_nil
      m.choice_i64_dyn.value?.should be_nil
      m.choice_i64_mult_dyn.value?.should be_nil
      #
      m.choice_f64.value?.should be_nil
      m.choice_f64_mult.value?.should be_nil
      m.choice_f64_dyn.value?.should be_nil
      m.choice_f64_mult_dyn.value?.should be_nil
      #
      m.file.value?.should be_nil
      m.image.value?.should be_nil
      #
      m.i64.value?.should be_nil
      m.f64.value?.should be_nil
      #
      m.bool.value?.should be_nil
      #
      # Param `default`
      m.url.default?.should be_nil
      m.text.default?.should be_nil
      m.phone.default?.should be_nil
      m.password.default?.should be_nil
      m.ip.default?.should be_nil
      m.hash2.default?.should be_nil
      m.email.default?.should be_nil
      m.color.default?.should eq("#000000")
      m.slug.default?.should be_nil
      #
      m.date.default?.should be_nil
      m.datetime.default?.should be_nil
      #
      m.choice_text.default?.should be_nil
      m.choice_text_mult.default?.should be_nil
      m.choice_text_dyn.default?.should be_nil
      m.choice_text_mult_dyn.default?.should be_nil
      #
      m.choice_i64.default?.should be_nil
      m.choice_i64_mult.default?.should be_nil
      m.choice_i64_dyn.default?.should be_nil
      m.choice_i64_mult_dyn.default?.should be_nil
      #
      m.choice_f64.default?.should be_nil
      m.choice_f64_mult.default?.should be_nil
      m.choice_f64_dyn.default?.should be_nil
      m.choice_f64_mult_dyn.default?.should be_nil
      #
      m.file.default?.should be_nil
      m.image.default?.should be_nil
      #
      m.i64.default?.should be_nil
      m.f64.default?.should be_nil
      #
      m.bool.default?.should be_false
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
