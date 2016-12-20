require "ostruct"
require "ostruct/sanitizer"

class User < OpenStruct
  include OStruct::Sanitizer

  truncate :first_name, :last_name, length: 10
  truncate :middle_name, length: 5, strip_whitespaces: false
  drop_punctuation :city, :country
  strip :email, :phone
  digits :ssn, :cell_phone
end
