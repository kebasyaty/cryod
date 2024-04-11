# ???
module DynFork::Commons::Converter
  extend self

  # ???
  def document_to_hash(doc_ptr : Pointer(BSON)) : Hash(String, DynFork::Globals::ValueTypes)
    field_type : String = ""
    name : String = ""
    doc = doc_ptr.value.not_nil!.to_h
    doc_hash = Hash(String, DynFork::Globals::ValueTypes).new
    #
    {% for field in @type.instance_vars %}
      name = @{{ field }}.name
      #
      (doc_hash[name] = doc["_id"].as(BSON::ObjectId).to_s) if name == "hash"
      #
      if !@{{ field }}.ignored?
        field_type = @{{ field }}.field_type
        if !(value = doc[name]).nil?
          case @{{ field }}.group
          when 1
            # ColorField | EmailField | PasswordField | PhoneField
            # | TextField | HashField | URLField | IPField
            if field_type != "PasswordField"
              doc_hash[name] = value.as(String)
            else
              doc_hash[name] = nil
            end
          when 2
            # DateField | DateTimeField
            if field_type.includes?("Time")
              doc_hash[name] = value.as(Time)
            else
              doc_hash[name] = value.as(Time)
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
                arr = value.as(Array(BSON::RecursiveValue)).map { |item| item.as(String)}
                doc_hash[name] = arr
              else
                doc_hash[name] = value.as(String)
              end
            elsif field_type.includes?("I64")
              if field_type.includes?("Mult")
                arr = value.as(Array(BSON::RecursiveValue)).map { |item| item.as(Int64)}
                doc_hash[name] = arr
              else
                doc_hash[name] = value.as(Int64)
              end
            elsif field_type.includes?("F64")
              if field_type.includes?("Mult")
                arr = value.as(Array(BSON::RecursiveValue)).map { |item| item.as(Float64)}
                doc_hash[name] = arr
              else
                doc_hash[name] = value.as(Float64)
              end
            end
          when 4
            # FileField
            bson = BSON.new
            value.as(Hash(String, BSON::RecursiveValue)).each { |key, val| bson[key] = val }
            doc_hash[name] = DynFork::Globals::FileData.from_bson(bson)
          when 5
            # ImageField
            bson = BSON.new
            value.as(Hash(String, BSON::RecursiveValue)).each { |key, val| bson[key] = val }
            doc_hash[name] = DynFork::Globals::ImageData.from_bson(bson)
          when 6
            # I64Field
            doc_hash[name] = value.as(Int64)
          when 7
            # F64Field
            doc_hash[name] = value.as(Float64)
          when 8
            # BoolField
            doc_hash[name] = value.as(Bool)
          when 9
            # SlugField
            doc_hash[name] = value.as(String)
          else
            raise DynFork::Errors::Model::InvalidGroupNumber
              .new(@@full_model_name, {{ field.name.stringify }})
          end
        else
          doc_hash[name] = nil
        end
      else
        (doc_hash[name] = nil) if name != "hash"
      end 
    {% end %}
    #
    doc_hash
  end
end
