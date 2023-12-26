# Validation of Model data before saving to the database.
module Crymon::Check
  # Output data for the Save method.
  struct OutputData
    getter data : BSON
    getter is_valid : Bool

    def initialize(@data : BSON, @is_valid : Bool); end
  end

  # Check data validity.
  # NOTE: The main use is to check data from web forms.
  def is_valid : Bool
    self.check.is_valid
  end

  # Validation of Model data.
  private def check : OutputData
    # Get model key.
    model_key : String = self.model_key
    # Get model name.
    model_name : String = Crymon::Globals.cache_metadata[model_key][:model_name]
    # Does the document exist in the database?
    is_updated : Bool = !@hash.value.nil?
    # Is there any incorrect data?
    is_error_symptom : Bool = false
    # Errors from additional validation of fields.
    error_map : Hash(String, String) = self.add_validation
    # Data to save or update to the database.
    db_data_bson : BSON = BSON.new
    # Current error message.
    err_msg : String?

    # Start checking all fields.
    {% for var in @type.instance_vars %}
      @{{ var }}.errors = Array(String).new
      #
      if err_msg = error_map[{{ var.name.stringify }}]?
          @{{ var }}.errors_accumulation(err_msg.to_s)
          (is_error_symptom = true) unless is_error_symptom
      end
      #
      unless @{{ var }}.is_ignored
        case @{{ var }}.group
        when 1
          # Validation of `text` type fields:
          # <br>
          # _"ColorField" | "EmailField" | "PasswordField" | "PhoneField"
          # | "TextField" | "HashField" | "URLField" | "IPField"_
          #
          # ...
        when 2
          # Validation of `slug` type fields:
          # <br>
          # "SlugField"
          # ...
        when 3
          # Validation of `date` type fields:
          # <br>
          # "DatField" | "DateTimeField"
          # ...
        when 4
          # Validation of `choice` type fields:
          # <br>
          # "ChoiceTextField" | "ChoiceU32Field"
          # | "ChoiceI64Field" | "ChoiceF64Field"
          # ...
        when 5
          # Validation of `choice` type fields:
          # <br>
          # "ChoiceTextDynField" | "ChoiceU32DynField"
          # | "ChoiceI64DynField" | "ChoiceF64DynField"
          # ...
        when 6
          # Validation of `choice` type fields:
          # <br>
          # "ChoiceTextMultField" | "ChoiceU32MultField"
          # | "ChoiceI64MultField" | "ChoiceF64MultField"
          # ...
        when 7
          # Validation of `choice` type fields:
          # <br>
          # "ChoiceTextMultDynField" | "ChoiceU32MultDynField"
          # | "ChoiceI64MultDynField" | "ChoiceF64MultDynField"
          # ...
        when 8
          # Validation of `file` type fields:
          # <br>
          # "FileField"
          # ...
        when 9
          # Validation of `file` type fields:
          # <br>
          # "ImageField"
          # ...
        when 10
          # Validation of `number` type fields:
          # <br>
          # "U32Field" | "I64Field"
          # ...
        when 11
          # Validation of `number` type fields:
          # <br>
          # "F64Field"
          # ...
        when 12
          # Validation of `boolean` type fields:
          # <br>
          # "BoolField"
          # ...
        else
          raise Crymon::Errors::InvalidGroupNumber
            .new(model_name, {{ var.name.stringify }})
        end
      end
    {% end %}
    #
    # --------------------------------------------------------------------------
    OutputData.new(db_data_bson, !is_error_symptom)
  end
end
