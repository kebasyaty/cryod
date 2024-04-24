module DynFork::Paladins::Groups
  # Validation of `choice` type fields:
  # <br>
  # _"ChoiceTextField" | "ChoiceI64Field"
  # | "ChoiceF64Field" | "ChoiceTextMultField"
  # | "ChoiceI64MultField" | "ChoiceF64MultField"
  # | "ChoiceTextMultField" | "ChoiceI64MultField"
  # | "ChoiceF64MultField" | "ChoiceTextMultDynField"
  # | "ChoiceI64MultDynField" | "ChoiceF64MultDynField"_
  def group_03(
    field_ptr : Pointer(DynFork::Globals::FieldTypes),
    error_symptom_ptr? : Pointer(Bool),
    save? : Bool,
    result_map_ptr : Pointer(Hash(String, DynFork::Globals::ResultMapType)),
    collection_ptr : Pointer(Mongo::Collection)
  ) : Nil
    # Get current value.
    current_value : DynFork::Globals::ValueTypes = (
      value : DynFork::Globals::ValueTypes = field_ptr.value.value? || field_ptr.value.default?
      # Validation, if the field is required and empty, accumulate the error.
      # ( The default value is used whenever possible )
      if value.nil?
        if field_ptr.value.required?
          self.accumulate_error(
            I18n.t(:required_field),
            field_ptr,
            error_symptom_ptr?
          )
        end
        (result_map_ptr.value[field_ptr.value.name] = nil) if save?
        return
      end
      value
    )
    # Does the field value match the possible options in choices.
    unless field_ptr.value.has_value?
      self.accumulate_error(
        I18n.t(:value_does_not_match),
        field_ptr,
        error_symptom_ptr?
      )
    end
    # Insert result.
    (result_map_ptr.value[field_ptr.value.name] = current_value) if save?
  end
end
