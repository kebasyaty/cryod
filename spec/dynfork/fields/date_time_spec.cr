require "../../spec_helper"

describe DynFork::Fields::DateTimeField do
  describe ".new" do
    it "=> create instance of Date-Time field", tags: "fields" do
      f = DynFork::Fields::DateTimeField.new
      f.id.should eq("")
      f.label.should eq("")
      f.field_type.should eq("DateTimeField")
      f.input_type.should eq("datetime")
      f.name.should eq("")
      f.value?.should be_nil
      f.default?.should be_nil
      f.time_object?.should be_nil
      f.placeholder.should eq("")
      f.disabled?.should be_false
      f.readonly?.should be_false
      f.hide?.should be_false
      f.required?.should be_false
      f.unique?.should be_false
      f.ignored?.should be_false
      f.max?.should be_nil
      f.min?.should be_nil
      f.hint.should eq("Formats: dd-mm-yyyy hh:mm:ss | dd/mm/yyyy hh:mm:ss | dd.mm.yyyy hh:mm:ss | dd-mm-yyyyThh:mm:ss | dd/mm/yyyyThh:mm:ss | dd.mm.yyyyThh:mm:ss | yyyy-mm-dd hh:mm:ss | yyyy/mm/dd hh:mm:ss | yyyy.mm.dd hh:mm:ss | yyyy-mm-ddThh:mm:ss | yyyy/mm/ddThh:mm:ss | yyyy.mm.ddThh:mm:ss")
      f.warning.should eq(Array(String).new)
      f.errors.should eq(Array(String).new)
      f.group.should eq(2_u8)
    end
  end
end
