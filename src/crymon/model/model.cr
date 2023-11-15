require "json"

module Crymon
  # For define metadata in models.
  annotation Meta; end

  # Abstraction for converting Crystal structures into Crymon Models.
  abstract struct Model
    include JSON::Serializable
    include JSON::Serializable::Strict

    getter hash = Crymon::Fields::HashField.new
    getter created_at = Crymon::Fields::DateTimeField.new("label": "Created at", "is_hide": true)
    getter updated_at = Crymon::Fields::DateTimeField.new("label": "Updated at", "is_hide": true)

    def initialize
      self.caching
      self.extra
    end

    # Additional initialization.
    def extra
      model_key : String = self.model_key
      var_name : String?
      # Injection of metadata from storage.
      {% for var in @type.instance_vars %}
        var_name = {{ var.name.stringify }}
        @{{ var }}.id = Crymon::Globals.cache_metadata[model_key][:field_attrs][var_name][:id]
        @{{ var }}.name = Crymon::Globals.cache_metadata[model_key][:field_attrs][var_name][:name]
      {% end %}
    end

    # Get model key.
    # NOTE: To access data in the cache.
    def model_key : String
      model_name : String = {{ @type.name.stringify }}.split("::").last
      service_name : String = {{ @type.annotation(Crymon::Meta)[:service_name] }} ||
        raise Crymon::Errors::MetaParameterMissing.new(model_name, "service_name")
      "#{service_name}_#{model_name}"
    end

    # Determine the presence of a variable (field) in the model.
    def []?(variable) : Bool
      {% for var in @type.instance_vars %}
        if {{ var.name.stringify }} == variable
          return true
        end
      {% end %}
      false
    end

    # Get a list of field names and their values.
    def field_name_and_value_list : Hash(String, Crymon::Globals::FieldTypes)
      fields = Hash(String, Crymon::Globals::FieldTypes).new
      {% for var in @type.instance_vars %}
        fields[{{ var.name.stringify }}] = @{{ var }}
      {% end %}
      fields
    end

    # Add metadata to the global store.
    def caching
      # Get model key.
      model_key : String = self.model_key
      # Stop caching if metadata is in storage.
      return unless Crymon::Globals.cache_metadata[model_key]?.nil?
      # Check the model for the presence of variables (fields).
      {% if @type.instance_vars.size < 4 %}
        # If there are no fields in the model, a FieldsMissing exception is raise.
        raise Crymon::Errors::ModelFieldsMissing.new({{ @type.name.stringify }}.split("::").last)
      {% end %}
      # Get model name = structure name.
      # <br>
      # _Examples: electric_car_store | electric-car-store | Electric-Car_Store | ElectricCarStore_
      # WARNING: Maximum 25 characters.
      model_name : String = {{ @type.name.stringify }}.split("::").last
      raise Crymon::Errors::ModelNameExcessChars.new(model_name) if model_name.size > 25
      unless Crymon::Globals.cache_regex[:model_name].matches?(model_name)
        raise Crymon::Errors::ModelNameRegexFails.new(model_name, "/^[A-Z][a-zA-Z0-9]{0,24}$/")
      end
      # Get service name = module name.
      # <br>
      # _Examples: Accounts | Smartphones | Washing machines | etc ..._
      # WARNING: Maximum 25 characters.
      service_name : String = {{ @type.annotation(Crymon::Meta)[:service_name] }} ||
        raise Crymon::Errors::MetaParameterMissing.new(model_name, "service_name")
      raise Crymon::Errors::MetaParamExcessChars.new(model_name, "service_name", 25) if service_name.size > 25
      unless Crymon::Globals.cache_regex[:service_name].matches?(service_name)
        raise Crymon::Errors::MetaParamRegexFails.new(model_name, "service_name", "/^[A-Z][a-zA-Z0-9]{0,24}$/")
      end
      # Get collection name.
      # WARNING: Maximum 50 characters.
      collection_name : String = "#{service_name}_#{model_name}"
      # Get list of names and types of variables (fields).
      # <br>
      # _Format: <field_name, field_type>_
      field_name_and_type_list : Hash(String, String) = (
        {% if @type.instance_vars.size > 3 %}
          Hash.zip(
            {{ @type.instance_vars.map &.name.stringify }},
            {{ @type.instance_vars.map &.type.stringify }}
              .map { |name| name.split("::").last }
          )
        {% else %}
          Hash(String, String).new
        {% end %}
      )
      # Get default value list.
      # <br>
      # _Format: <field_name, default_value>_
      default_value_list : Hash(String, Crymon::Globals::ValueTypes) = (
        {% if @type.instance_vars.size > 3 %}
          hash = Hash(String, Crymon::Globals::ValueTypes).new
          self.field_name_and_value_list.each do |key, value|
            hash[key] = value.default
          end
          hash
        {% else %}
          Hash(String, Crymon::Globals::ValueTypes).new
        {% end %}
      )
      # Get list of field names that will not be saved to the database.
      ignore_fields : Array(String) = {{ @type.annotation(Crymon::Meta)[:ignore_fields] }} ||
        Array(String).new
      (field_name_list = field_name_and_type_list.keys
      ignore_fields.each do |field_name|
        unless field_name_list.includes?(field_name)
          raise Crymon::Errors::MetaIgnoredFieldMissing.new(model_name, "ignore_fields", field_name)
        end
      end)
      # Get attributes value for fields of Model: id, name.
      field_attrs : Hash(String, NamedTuple(id: String, name: String)) = (
        hash = Hash(String, NamedTuple(id: String, name: String)).new
        {% if @type.instance_vars.size > 3 %}
          {% for var in @type.instance_vars %}
            hash[{{ var.name.stringify }}] = {
              id: "#{{{ @type.name.stringify }}.split("::").last}--#{{{ var.name.stringify }}.gsub("_", "-")}",
              name: {{ var.name.stringify }}
            }
          {% end %}
        {% end %}
        hash
      )
      # Get data for dynamic fields.
      data_dynamic_fields : Hash(String, Crymon::Globals::DataDynamicTypes) = (
        hash = Hash(String, Crymon::Globals::DataDynamicTypes).new
        super_collection = Crymon::Globals.cache_mongo_client[
          Crymon::Globals.cache_database_name][
          Crymon::Globals.cache_super_collection_name]
      )
      #
      # Add metadata to the global store.
      Crymon::Globals.cache_metadata[model_key] = {
        # Model name = Structure name.
        model_name: model_name,
        # Service Name = Application subsection = Module name.
        service_name: service_name,
        # Collection name.
        collection_name: collection_name,
        # limiting query results.
        db_query_docs_limit: {{ @type.annotation(Crymon::Meta)[:db_query_docs_limit] }} || 1000_u32,
        # Number of variables (fields).
        field_count: {{ @type.instance_vars.size }},
        # List of names and types of variables (fields).
        # <br>
        # _Format: <field_name, field_type>_
        field_name_and_type_list: field_name_and_type_list,
        # Default value list.
        # <br>
        # _Format: <field_name, default_value>_
        default_value_list: default_value_list,
        # Create documents in the database. By default = true.
        # NOTE: false - Alternatively, use it to validate data from web forms.
        is_add_doc: {{ @type.annotation(Crymon::Meta)[:is_add_doc] }} || true,
        # Update documents in the database.
        is_up_doc: {{ @type.annotation(Crymon::Meta)[:is_up_doc] }} || true,
        # Delete documents from the database.
        is_del_doc: {{ @type.annotation(Crymon::Meta)[:is_del_doc] }} || true,
        # Allows methods for additional actions and additional validation.
        is_use_addition: {{ @type.annotation(Crymon::Meta)[:is_use_addition] }} || false,
        # Allows hooks methods - impl Hooks for ModelName.
        is_use_hooks: {{ @type.annotation(Crymon::Meta)[:is_use_hooks] }} || false,
        # Is the hash field used for the slug?
        is_use_hash_slug: {{ @type.annotation(Crymon::Meta)[:is_use_hash_slug] }} || false,
        # List of field names that will not be saved to the database.
        ignore_fields: ignore_fields,
        # Attributes value for fields of Model: id, name.
        field_attrs: field_attrs,
        # Data for dynamic fields.
        data_dynamic_fields: Hash(String, Crymon::Globals::DataDynamicTypes).new,
      }
    end
  end
end
