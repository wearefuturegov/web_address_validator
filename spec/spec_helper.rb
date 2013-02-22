require 'rspec'
require 'active_model'
require_relative '../lib/web_address_validator'

class TestModel
  include ActiveModel::Validations

  attr_accessor :url

  validates :url, :web_address => true

  def initialize(url)
    @url = url
  end
end
