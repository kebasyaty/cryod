require "../spec_helper"

describe Crymon::Model do
  describe ".new" do
    it "create instance of empty Model" do
      m = Helper::EmptyModel.new
      m.model_name.should eq("EmptyModel")
      m.vars_count.should eq(0_i32)
      m.instance_vars_names.should eq(Array(String).new)
      m.instance_vars_types.should eq(Array(String).new)
      m.instance_vars_name_and_type.should eq(Hash(String, String).new)
      m.has_instance_var?("???").should be_false
      # Testing metadata.
      metadata = m.meta
      metadata["app_name"].should eq(Settings::APP_NAME)
      metadata["unique_app_key"].should eq(Settings::UNIQUE_APP_KEY)
      metadata["service_name"].should eq(Settings::SERVICE_NAME)
      metadata["database_name"].should eq(Settings::DATABASE_NAME)
      metadata["collection_name"].should eq(Settings::COLLECTION_NAME)
      metadata["db_query_docs_limit"].should eq(1000_u32)
      metadata["is_add_doc"].should be_true
      metadata["is_up_doc"].should be_true
      metadata["is_del_doc"].should be_true
      metadata["is_use_addition"].should be_false
      metadata["is_use_hooks"].should be_false
      metadata["is_use_hash_slug"].should be_false
      metadata["ignore_fields"].should eq(Array(String).new)
    end

    it "create instance of filled Model" do
      m = Helper::FilledModel.new(name: "Gene", age: 32_u32)
      m.model_name.should eq("FilledModel")
      m.vars_count.should eq(3_i32)
      m.instance_vars_names.should eq(["name", "age", "birthday"])
      m.instance_vars_types.should eq(["String", "UInt32", "Birthday"])
      m.instance_vars_name_and_type.should eq(
        {"name" => "String", "age" => "UInt32", "birthday" => "Birthday"}
      )
      m.has_instance_var?("name").should be_true
      m.has_instance_var?("age").should be_true
      m.has_instance_var?("birthday").should be_true
      m.has_instance_var?("???").should be_false
      m.name.should eq("Gene")
      m.age.should eq(32_u32)
      m.birthday.should eq(Helper::Birthday.new)
      m.birthday.date.should eq("1990-11-7")
      # Testing metadata.
      metadata = m.meta
      metadata["app_name"].should eq(Settings::APP_NAME)
      metadata["unique_app_key"].should eq(Settings::UNIQUE_APP_KEY)
      metadata["service_name"].should eq(Settings::SERVICE_NAME)
      metadata["database_name"].should eq(Settings::DATABASE_NAME)
      metadata["collection_name"].should eq(Settings::COLLECTION_NAME)
      metadata["db_query_docs_limit"].should eq(2000_u32)
      metadata["is_add_doc"].should be_true
      metadata["is_up_doc"].should be_true
      metadata["is_del_doc"].should be_true
      metadata["is_use_addition"].should be_false
      metadata["is_use_hooks"].should be_false
      metadata["is_use_hash_slug"].should be_false
      metadata["ignore_fields"].should eq(["age", "birthday"])
    end
  end
end
