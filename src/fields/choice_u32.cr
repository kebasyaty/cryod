require "./field"

module Fields
  # Type of selective field with static of elements.
  # With a single choice.
  class ChoiceU32Field < Fields::Field
    # Field type - Class Name.
    getter field_type : String = "ChoiceU32Field"
    # Sets the value of an element.
    property value : String | Nil
    # Value by default.
    property default : String | Nil
    # Specifies that multiple options can be selected at once.
    getter is_multiple : Bool = false
    # The unique value of a field in a collection.
    property is_unique : Bool = false
    # Example: [{5, "Title"}, {10, "Title 2"}].
    # Html tag: select
    property choices : Array(Tuple(UInt32, String)) = Array(Tuple(UInt32, String)).new
    # To optimize field traversal in the `paladins/check()` method.
    # Hint: It is recommended not to change.
    getter group : UInt32 = 4
  end

  # Type of selective field with static of elements.
  # With multiple choice.
  class ChoiceU32MultField < Fields::Field
    # Field type - Class Name.
    getter field_type : String = "ChoiceU32MultField"
    # Sets the value of an element.
    property value : String | Nil
    # Value by default.
    property default : String | Nil
    # Specifies that multiple options can be selected at once.
    getter is_multiple : Bool = true
    # The unique value of a field in a collection.
    property is_unique : Bool = false
    # Example: [{5, "Title"}, {10, "Title 2"}].
    # Html tag: select multiple
    property choices : Array(Tuple(UInt32, String)) = Array(Tuple(UInt32, String)).new
    # To optimize field traversal in the `paladins/check()` method.
    # Hint: It is recommended not to change.
    getter group : UInt32 = 6
  end

  # Type of selective field with dynamic addition of elements.
  # For simulate relationship Many-to-One.
  # Elements are added via the `ModelName::update_dyn_field()` method.
  class ChoiceU32DynField < Fields::Field
    # Field type - Class Name.
    getter field_type : String = "ChoiceU32DynField"
    # Sets the value of an element.
    property value : String | Nil
    # Specifies that multiple options can be selected at once.
    getter is_multiple : Bool = false
    # The unique value of a field in a collection.
    property is_unique : Bool = false
    # Example: [{5, "Title"}, {10, "Title 2"}].
    # Html tag: select
    property choices : Array(Tuple(UInt32, String)) = Array(Tuple(UInt32, String)).new
    # To optimize field traversal in the `paladins/check()` method.
    # Hint: It is recommended not to change.
    getter group : UInt32 = 5
  end

  # Type of selective field with dynamic addition of elements.
  # For simulate relationship Many-to-Many.
  # Elements are added via the `ModelName::update_dyn_field()` method.
  class ChoiceU32MultDynField < Fields::Field
    # Field type - Class Name.
    getter field_type : String = "ChoiceU32MultDynField"
    # Sets the value of an element.
    property value : String | Nil
    # Specifies that multiple options can be selected at once.
    getter is_multiple : Bool = true
    # The unique value of a field in a collection.
    property is_unique : Bool = false
    # Example: [{5, "Title"}, {10, "Title 2"}].
    # Html tag: select
    property choices : Array(Tuple(UInt32, String)) = Array(Tuple(UInt32, String)).new
    # To optimize field traversal in the `paladins/check()` method.
    # Hint: It is recommended not to change.
    getter group : UInt32 = 7
  end
end
