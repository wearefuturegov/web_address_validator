require 'rspec'
require 'active_model'
require_relative '../lib/web_address_validator'

class ValidatableModel
  include ActiveModel::Validations
  attr_accessor :value
  def initialize(value)
    @value = value
  end
end

class TestModel < ValidatableModel
  validates :value, :web_address => true
end
