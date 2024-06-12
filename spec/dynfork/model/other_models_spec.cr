require "../../spec_helper"

describe DynFork::Model do
  describe ".new" do
    # it "=> create instance of empty Model", tags: "model" do
    #   ex = expect_raises(DynFork::Errors::Model::FieldsMissing) do
    #     Spec::Data::EmptyModel.new
    #   end
    #   ex.message.should eq("Model `Spec::Data::EmptyModel` has no fields!")
    # end

    it "=> create instance of filled Model", tags: "model" do
      m = Spec::Data::FilledModel.new
      #
      m.first_name.id.should eq("FilledModel--first-name")
      m.first_name.name.should eq("first_name")
      m.age.id.should eq("FilledModel--age")
      m.age.name.should eq("age")
      m.birthday.id.should eq("FilledModel--birthday")
      m.birthday.name.should eq("birthday")
      m.hash.id.should eq("FilledModel--hash")
      m.hash.name.should eq("hash")
      m.created_at.id.should eq("FilledModel--created-at")
      m.created_at.name.should eq("created_at")
      m.updated_at.id.should eq("FilledModel--updated-at")
      m.updated_at.name.should eq("updated_at")
      #
      m.first_name.value = "Gene"
      m.age.value = 32_i64
      m.birthday.value = "23.12.2023"
      m.birthday.time_object?.should eq(DynFork::Globals::Date.date_parse("23.12.2023"))
      m.hash.value?.should be_nil
      m.object_id.should be_nil
      m.hash.object_id.should be_nil
      m.hash.value = "507f191e810c19729de860ea"
      m.object_id.should eq(BSON::ObjectId.new("507f191e810c19729de860ea"))
      m.hash.object_id.should eq(BSON::ObjectId.new("507f191e810c19729de860ea"))
      m.created_at.value = "2023-11-02T12:15:00"
      m.updated_at.value = "24.12.2023T08:54:00"
      m.updated_at.time_object?.should eq(DynFork::Globals::Date.datetime_parse("24.12.2023T08:54:00"))
      #
      m.first_name.value.should eq("Gene")
      m.age.value.should eq(32_i64)
      m.hash.value.should eq("507f191e810c19729de860ea")
      m.created_at.value.should eq("2023-11-02T12:15:00")
      m.updated_at.value.should eq("24.12.2023T08:54:00")
      # Testing metadata.
      metadata = Spec::Data::FilledModel.meta
      metadata["model_name"].should eq("FilledModel")
      metadata["service_name"].should eq("ServiceName")
      metadata["fixture_name"].should be_nil
      metadata["collection_name"].should eq("ServiceName_FilledModel")
      metadata["db_query_docs_limit"].should eq(2000_i32)
      metadata["field_count"].should eq(6_i32)
      metadata["field_name_and_type_list"].should eq(
        {"created_at" => "DateTimeField",
         "updated_at" => "DateTimeField",
         "first_name" => "TextField"}
      )
      metadata["migrat_model?"].should be_true
      metadata["create_doc?"].should be_false
      metadata["update_doc?"].should be_false
      metadata["delete_doc?"].should be_false
    end

    it "=> create instance of AuxiliaryModel", tags: "model" do
      Spec::Data::AuxiliaryModel.new
      metadata = Spec::Data::AuxiliaryModel.meta
      metadata["service_name"].should eq("ServiceName")
    end

    it "=> create instance of AAModel", tags: "model" do
      Spec::Data::AAModel.new
      metadata = Spec::Data::AAModel.meta
      metadata["service_name"].should eq("Accounts")
      metadata["migrat_model?"].should be_true
      metadata["create_doc?"].should be_true
      metadata["update_doc?"].should be_true
      metadata["delete_doc?"].should be_true
    end

    # it "=> create instance of SlugSourceInvalidModel", tags: "model" do
    #   ex = expect_raises(DynFork::Errors::Fields::SlugSourceNameInvalid) do
    #     Spec::Data::SlugSourceInvalidModel.new
    #   end
    #   ex.message.should eq(
    #     "Model: `Spec::Data::SlugSourceInvalidModel` > Field: `slug` > Attribute: `slug_sources` => " +
    #     "The `first_name` field missing in Model!"
    #   )
    # end

    # describe "#caching" do
    #   it "=> Model without mandatory 'service_name' parameter for metadata", tags: "model" do
    #     ex = expect_raises(DynFork::Errors::Meta::ParameterMissing) do
    #       Spec::Data::NoParamServiceNameModel.new
    #     end
    #     ex.message.should eq(
    #       "Model: `Spec::Data::NoParamServiceNameModel` => Missing `service_name` parameter for Meta!"
    #     )
    #   end
    # end
  end
end
