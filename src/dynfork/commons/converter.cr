# ???
module DynFork::Commons::Converter
  extend self

  # ???
  def document_to_hash(doc_ptr : Pointer(BSON)) : Hash(String, DynFork::Globals::ValueTypes)
    doc = doc_ptr.value.not_nil!.to_h
    doc_hash = Hash(String, DynFork::Globals::ValueTypes).new
    #
    @@meta.not_nil![:field_name_and_type_list].each do |field_name, field_type|
      (doc_hash[field_name] = doc["_id"].as(BSON::ObjectId).to_s) if field_name == "hash"
      #
      if !(value = doc[field_name]).nil?
        if ["ColorField", "EmailField", "PhoneField", "TextField", "HashField", "URLField", "IPField"].includes?(field_type)
            doc_hash[field_name] = value.as(String)
        elsif ["DateField", "DateTimeField"].includes?(field_type)
          if field_type.includes?("Time")
            doc_hash[field_name] = value.as(Time).to_s("%FT%H:%M:%S")
          else
            doc_hash[field_name] = value.as(Time).to_s("%F")
          end
        when 3
          # ChoiceTextField | ChoiceI64Field
          # | ChoiceF64Field | ChoiceTextMultField
          # | ChoiceI64MultField | ChoiceF64MultField
          # | ChoiceTextMultField | ChoiceI64MultField
          # | ChoiceF64MultField | ChoiceTextMultDynField
          # | ChoiceI64MultDynField | ChoiceF64MultDynField
          if field_type.includes?("Text")
            if field_type.includes?("Mult")
              arr = value.as(Array(BSON::RecursiveValue)).map { |item| item.as(String) }
              doc_hash[field_name] = arr
            else
              doc_hash[field_name] = value.as(String)
            end
          elsif field_type.includes?("I64")
            if field_type.includes?("Mult")
              arr = value.as(Array(BSON::RecursiveValue)).map { |item| item.as(Int64) }
              doc_hash[field_name] = arr
            else
              doc_hash[field_name] = value.as(Int64)
            end
          elsif field_type.includes?("F64")
            if field_type.includes?("Mult")
              arr = value.as(Array(BSON::RecursiveValue)).map { |item| item.as(Float64) }
              doc_hash[field_name] = arr
            else
              doc_hash[field_name] = value.as(Float64)
            end
          end
        when "FileField"
          bson = BSON.new
          value.as(Hash(String, BSON::RecursiveValue)).each { |key, val| bson[key] = val }
          doc_hash[field_name] = DynFork::Globals::FileData.from_bson(bson)
        when "ImageField"
          bson = BSON.new
          value.as(Hash(String, BSON::RecursiveValue)).each { |key, val| bson[key] = val }
          doc_hash[field_name] = DynFork::Globals::ImageData.from_bson(bson)
        when "I64Field"
          doc_hash[field_name] = value.as(Int64)
        when "F64Field"
          doc_hash[field_name] = value.as(Float64)
        when "BoolField"
          doc_hash[field_name] = value.as(Bool)
        when "SlugField"
          doc_hash[field_name] = value.as(String)
        when "PasswordField"
          doc_hash[field_name] = nil
        else
          raise DynFork::Errors::Model::InvalidGroupNumber
            .new(@@full_model_name, {{ field.name.stringify }})
        end
      else
        doc_hash[field_name] = nil
      end
    end
    #
    doc_hash
  end
end