require "ostruct"
require "ostruct/sanitizer"

class User < OpenStruct
  include OStruct::Sanitizer

  truncate :first_name, :last_name, length: 10
  truncate :middle_name, length: 3, strip_whitespaces: false
  alphanumeric :city, :country
  strip :email, :phone
  digits :ssn, :cell_phone
end
