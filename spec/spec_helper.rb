require 'rspec'
require 'active_model'
require_relative '../lib/web_address_validator'

class BaseModel
  include ActiveModel::Validations
  attr_accessor :value
  def initialize(value)
    @value = value
  end
end

class DirtyModel < BaseModel
  include ActiveModel::Dirty
  define_attribute_methods [:value]

  def value
    @value
  end

  def value=(val)
    value_will_change! unless val == @name
    @value = val
  end

  def save
    @previously_changed = changes
    @changed_attributes.clear
  end
end
