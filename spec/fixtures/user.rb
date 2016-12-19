require "ostruct"
require "ostruct/sanitizer"

class User < OpenStruct
  include OStruct::Sanitizer

  truncate :first_name, :last_name, length: 10
end
