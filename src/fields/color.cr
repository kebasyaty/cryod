require "./field"

module Fields
  # Field for entering color.
  # The default value is #000000 (black).
  # Examples: #fff | #f2f2f2 | #ffffff00 | rgb(255,0,24) | rgba(255,0,24,0.5) |
  # rgba(#fff,0.5) | hsl(120,100%,50%) | hsla(170,23%,25%,0.2) | 0x00ffff.
  struct ColorField < Fields::Field
    # Field type - Structure Name.
    getter field_type : String = "ColorField"
    # Html tag: input type="color".
    # Example: #000000 (black)
    # WARNING: type="color" only seven-character hexadecimal notation.
    getter input_type : String = "text"
    # Sets the value of an element.
    property value : String | Nil
    # Value by default.
    property default : String | Nil
    # Displays prompt text.
    property placeholder : String
    # The maximum number of characters allowed in the text.
    property maxlength : UInt32
    # The minimum number of characters allowed in the text.
    property minlength : UInt32
    # The unique value of a field in a collection.
    property is_unique : Bool
    # To optimize field traversal in the `paladins/check()` method.
    # Hint: It is recommended not to change.
    getter group : UInt32 = 1

    def initialize(
      @label : String = "",
      @default : String | Nil = "#000000",
      @placeholder : String = "",
      @maxlength : UInt32 = 256,
      @minlength : UInt32 = 0,
      @is_hide : Bool = false,
      @is_unique : Bool = false,
      @is_required : Bool = false,
      @is_disabled : Bool = false,
      @is_readonly : Bool = false,
      @other_attrs : String = "",
      @css_classes : String = "",
      @hint : String = ""
    ); end
  end
end
