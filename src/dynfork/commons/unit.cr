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
    # Create a search filter.
    filter = {"collection_name": @@meta.not_nil![:collection_name]}
    # Get Model state.
    model_state : DynFork::Migration::ModelState = (
      document = super_collection.find_one(filter)
      DynFork::Migration::ModelState.from_bson(document)
    )
    # Insert, update or delete unit.
    if !unit.delete?
      # Insert or update.
      model_state.data_dynamic_fields[unit.title] = unit.value.to_s
    else
      # Delete key.
      if model_state.data_dynamic_fields.delete(unit.title).nil?
        self.error_key_missing(unit.title)
      end
    end
    # Update the state of the model in the database.
    update = {"$set": {"data_dynamic_fields": model_state.data_dynamic_fields}}
    super_collection.update_one(filter, update)
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
