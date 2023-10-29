require "./field"

module Crymon
  module Fields
    # Type of selective field with static of elements.
    # NOTE: With a single choice.
    struct ChoiceF64Field < Fields::Field
      # Field type - Structure Name.
      getter field_type : String = "ChoiceF64Field"
      # Sets the value of an element.
      property value : Float64 | Nil
      # Value by default.
      property default : Float64 | Nil
      # Specifies that multiple options can be selected at once.
      getter is_multiple : Bool = false
      # The unique value of a field in a collection.
      property is_unique : Bool
      # Example: [{5.0, "Title"}, {5.25, "Title 2"}].
      # NOTE: Html tag: select
      property choices : Array(Tuple(Float64, String))
      # To optimize field traversal in the `paladins/check()` method.
      # WARNING: It is recommended not to change.
      getter group : UInt8 = 4

      def initialize(
        @label : String = "",
        @default : Float64 | Nil = nil,
        @is_hide : Bool = false,
        @is_unique : Bool = false,
        @is_required : Bool = false,
        @is_disabled : Bool = false,
        @is_readonly : Bool = false,
        @other_attrs : String = "",
        @css_classes : String = "",
        @hint : String = "",
        @choices : Array(Tuple(Float64, String)) = Array(Tuple(Float64, String)).new
      ); end

      # Check for variable existence.
      def []?(variable) : Bool
        {% for var in @type.instance_vars %}
          if {{ var.name.stringify }} == variable
              return true
          end
        {% end %}
        false
      end
    end

    # Type of selective field with static of elements.
    # NOTE: With multiple choice.
    struct ChoiceF64MultField < Fields::Field
      # Field type - Structure Name.
      getter field_type : String = "ChoiceF64MultField"
      # Sets the value of an element.
      property value : Array(Float64) | Nil
      # Value by default.
      property default : Array(String) | Nil
      # Specifies that multiple options can be selected at once.
      getter is_multiple : Bool = true
      # The unique value of a field in a collection.
      property is_unique : Bool
      # Example: [{5.0, "Title"}, {5.25, "Title 2"}].
      # NOTE: Html tag: select multiple
      property choices : Array(Tuple(Float64, String))
      # To optimize field traversal in the `paladins/check()` method.
      # WARNING: It is recommended not to change.
      getter group : UInt8 = 6

      def initialize(
        @label : String = "",
        @default : Array(Float64) | Nil = nil,
        @is_hide : Bool = false,
        @is_unique : Bool = false,
        @is_required : Bool = false,
        @is_disabled : Bool = false,
        @is_readonly : Bool = false,
        @other_attrs : String = "",
        @css_classes : String = "",
        @hint : String = "",
        @choices : Array(Tuple(Float64, String)) = Array(Tuple(Float64, String)).new
      ); end

      # Check for variable existence.
      def []?(variable) : Bool
        {% for var in @type.instance_vars %}
          if {{ var.name.stringify }} == variable
              return true
          end
        {% end %}
        false
      end
    end

    # Type of selective field with dynamic addition of elements.
    # NOTE: For simulate relationship Many-to-One.
    # NOTE: Elements are added via the `ModelName::update_dyn_field()` method.
    struct ChoiceF64DynField < Fields::Field
      # Field type - Structure Name.
      getter field_type : String = "ChoiceF64DynField"
      # Sets the value of an element.
      property value : Float64 | Nil
      # Specifies that multiple options can be selected at once.
      getter is_multiple : Bool = false
      # The unique value of a field in a collection.
      property is_unique : Bool
      # Example: [{5.0, "Title"}, {5.25, "Title 2"}].
      # NOTE: Html tag: select
      property choices : Array(Tuple(Float64, String))
      # To optimize field traversal in the `paladins/check()` method.
      # WARNING: It is recommended not to change.
      getter group : UInt8 = 5

      def initialize(
        @label : String = "",
        @is_hide : Bool = false,
        @is_unique : Bool = false,
        @is_required : Bool = false,
        @is_disabled : Bool = false,
        @is_readonly : Bool = false,
        @other_attrs : String = "",
        @css_classes : String = "",
        @hint : String = "",
        @choices : Array(Tuple(Float64, String)) = Array(Tuple(Float64, String)).new
      ); end

      # Check for variable existence.
      def []?(variable) : Bool
        {% for var in @type.instance_vars %}
          if {{ var.name.stringify }} == variable
              return true
          end
        {% end %}
        false
      end
    end

    # Type of selective field with dynamic addition of elements.
    # NOTE: For simulate relationship Many-to-Many.
    # NOTE: Elements are added via the `ModelName::update_dyn_field()` method.
    struct ChoiceF64MultDynField < Fields::Field
      # Field type - Structure Name.
      getter field_type : String = "ChoiceF64MultDynField"
      # Sets the value of an element.
      property value : Array(Float64) | Nil
      # Specifies that multiple options can be selected at once.
      getter is_multiple : Bool = true
      # The unique value of a field in a collection.
      property is_unique : Bool
      # Example: [{5.0, "Title"}, {5.25, "Title 2"}].
      # NOTE: Html tag: select
      property choices : Array(Tuple(Float64, String))
      # To optimize field traversal in the `paladins/check()` method.
      # WARNING: It is recommended not to change.
      getter group : UInt8 = 7

      def initialize(
        @label : String = "",
        @is_hide : Bool = false,
        @is_unique : Bool = false,
        @is_required : Bool = false,
        @is_disabled : Bool = false,
        @is_readonly : Bool = false,
        @other_attrs : String = "",
        @css_classes : String = "",
        @hint : String = "",
        @choices : Array(Tuple(Float64, String)) = Array(Tuple(Float64, String)).new
      ); end

      # Check for variable existence.
      def []?(variable) : Bool
        {% for var in @type.instance_vars %}
          if {{ var.name.stringify }} == variable
              return true
          end
        {% end %}
        false
      end
    end
  end
end
