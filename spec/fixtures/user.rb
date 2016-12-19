require "ostruct"
require "ostruct/sanitizer"

class User < OpenStruct
  include OStruct::Sanitizer

  truncate :first_name, :last_name, length: 10
  drop_punctuation :city, :country
  strip :email, :phone
end
