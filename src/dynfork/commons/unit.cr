# Units Management.
# NOTE: Management for `choices` parameter in dynamic field types.
module DynFork::Commons::UnitsManagement
  extend self

  # For insert, update and delete units.
  # NOTE: Management for `choices` parameter in dynamic field types.
  #
  # Example:
  # ```
  # @[DynFork::Meta(service_name: "Accounts")]
  # struct User < DynFork::Model
  #   getter username = DynFork::Fields::TextField.new
  #   getter birthday = DynFork::Fields::DateField.new
  # end
  #
  # unit = DynFork::Globals::DynUnit.new(
  #   field: "field_name",
  #   title: "Title",
  #   value: "value", # String | Int64 | Float64
  #   delete: false   # default is the same as false
  # )
  #
  # User.unit_manager unit
  # ```
  #
  def unit_manager(unit : DynFork::Globals::Unit)
    # Unit validation.
    if unit.field.empty?
      self.error_empty_field("field")
    end
    if unit.title.empty?
      self.error_empty_field("title")
    end
    if unit.value.is_a?(String) && unit.value.to_s.empty?
      self.error_empty_field("value")
    end
    # Get super collection.
    # Contains model state and dynamic field data.
    super_collection = DynFork::Globals.cache_mongo_database[
      DynFork::Globals.cache_super_collection_name]
    # Get Model state.
    model_state : DynFork::Migration::ModelState = (
      filter = {"collection_name": @@meta.not_nil![:collection_name]}
      document = super_collection.find_one(filter)
      DynFork::Migration::ModelState.from_bson(document)
    )
    #
    if unit.delete?
      unit.data_dynamic_fields.has_key?(unit.field)
    else
      # ...
    end
  end

  private def error_empty_field(field : String)
    msg = "Model: `#{self.full_model_name}` > " +
          "Method: `unit_manager` > " +
          "Argument: `unit` > " +
          "Field `#{field}` => Must not be empty!"
    raise DynFork::Errors::Panic.new msg
  end

  private def error_key_missing(field : String)
    msg = "Model: `#{self.full_model_name}` > " +
          "Method: `unit_manager` => " +
          "Cannot delete, key `#{field}` is missing!"
    raise DynFork::Errors::Panic.new msg
  end
end
