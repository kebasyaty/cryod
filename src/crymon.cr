# Crymon:
require "./crymon/errors/*"
#
require "./crymon/globals/globals"
require "./crymon/tools/*"
#
require "./crymon/fields/*"
#
require "./crymon/meta"
require "./crymon/model"
#
require "./crymon/migration"
#
# Third party libraries:
require "cryomongo"
require "bson"
require "i18n"
require "validator"
require "pluto"
require "pluto/format/jpeg"
require "pluto/format/png"
require "pluto/format/webp"
#
# Standard:
require "crypto/bcrypt/password"

# ORM-like API MongoDB for Crystal.
# <br>
# For simulate relationship Many-to-One and Many-to-Many,
# <br>
# a simplified alternative (Types of selective fields with dynamic addition of elements) is used.
# <br>
# The project is focused on web development.
# <br>
# <br>
# _Compatible with MongoDB 3.6+. Tested against: 6.0, 7.0._
# <br>
# _For more information see [Cryomongo](https://github.com/elbywan/cryomongo "Cryomongo")_.
module Crymon
  VERSION = "0.1.0"
end

module Validator
  # Custom validator for checking color code.
  def self.color?(value) : Bool
    return true if value.is_a?(String) &&
                   Crymon::Globals.cache_regex[:color_code].matches?(value)
    false
  end
end
