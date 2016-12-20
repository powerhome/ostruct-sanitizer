require "ostruct"
require "ostruct/sanitizer/version"

module OStruct
  # Provides a series of sanitization rules to be applied on OpenStruct fields on
  # a Rails-ish fashion.
  #
  # @example
  #   class Person < OpenStruct
  #     include WellsFargoRetail::Sanitizer
  #
  #     truncate :name, length: 20
  #     drop_punctuation :name
  #     sanitize :middle_name do |value|
  #       # Perform a more complex sanitization process
  #     end
  #   end
  #
  module Sanitizer
    def self.included(base)
      unless base.ancestors.include? OpenStruct
        raise "#{self.name} can only be used within OpenStruct classes"
      end

      base.extend ClassMethods
    end

    # Initializes the OpenStruct applying any registered sanitization rules
    #
    def initialize(attrs = {})
      super
      attrs.each_pair do |field, value|
        self.send("#{field}=", value)
      end
    end

    # Overrides ostruct member definition applying sanitization rules when needed
    #
    # @param [#to_sym] field the name of the field being defined
    # @return [Symbol] the name of the defined field
    #
    def new_ostruct_member(field)
      field = field.to_sym
      unless respond_to?(field)
        define_singleton_method(field) { modifiable[field] }
        define_singleton_method("#{field}=") do |value|
          modifiable[field] = sanitize(field, value)
        end
      end
      field
    end

    private

    def sanitize(field, value)
      return value if value.nil? || !sanitize?(field)
      self.class.sanitizers[field].reduce(value) do |current_value, sanitizer|
        sanitizer.call(current_value)
      end
    end

    def sanitize?(field)
      self.class.sanitizers.key? field
    end

    # Provides sanitization rules that can be declaratively applied to OpenStruct
    # fields, similar to hooks on Rails models.
    #
    module ClassMethods
      attr_accessor :sanitizers

      # Registers a sanitization block for a given field
      #
      # @param [Array<Symbol>] a list of field names to be sanitized
      # @param [#call] block sanitization block to be applied to the current value of each field and returns the new sanitized value
      #
      def sanitize(*fields, &block)
        @sanitizers ||= {}
        fields.each do |field|
          field_sanitizers = @sanitizers[field] ||= []
          field_sanitizers << block
        end
      end

      # Truncates fields to a given length value
      #
      # @param [Array<Symbol>] a list of field names to be sanitized
      # @param [Integer] length the amount to truncate the field's value to
      # @param [Boolean] strip_whitespaces whether or not to strip whitespaces
      #
      def truncate(*fields, length:, strip_whitespaces: true)
        strip(*fields) if strip_whitespaces
        sanitize(*fields) { |value| value[0...length] }
        strip(*fields) if strip_whitespaces
      end

      # Drops any punctuation character from the field's value
      #
      # @param [Array<Symbol>] a list of field names to be sanitized
      #
      def drop_punctuation(*fields)
        sanitize(*fields) { |value| value.gsub(/[^\w\s]/, '') }
      end

      # Strips out leading and trailing spaces from the values of the given fields
      #
      # @param [Array<Symbol>] fields list of fields to be sanitized
      #
      def strip(*fields)
        sanitize(*fields) { |value| value.strip }
      end

      # Removes any non-digit character from the values of the given fields
      #
      # @param [Array<Symbol>] fields list of fields to be sanitized
      #
      def digits(*fields)
        sanitize(*fields) { |value| value.to_s.gsub(/[^0-9]/, '') }
      end
    end
  end
end
