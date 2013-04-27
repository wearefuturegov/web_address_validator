require 'uri'
require 'resolv'

# TODO: locale file for error messages

class WebAddressValidator < ActiveModel::EachValidator

  @default_options = { :resolv => :dirty }
  class << self; attr_accessor :default_options; end

  def initialize(options)
    options.reverse_merge!(self.class.default_options)
    super(options)
  end

  def validate_each(record, attribute, value)
    uri = URI.parse(value)
    error_msg = begin
      if uri.scheme.nil?
        "is missing protocol (e.g. http://)"
      elsif uri.scheme != "http" && uri.scheme != "https"
        "contains invalid protocol, '#{uri.scheme}'"
      elsif uri.host.nil?
        "is missing host name (e.g. www.google.com)"
      elsif !uri.host.match(/\.[a-zA-Z]{2,}$/)
        "is missing top level domain name (e.g. .com)"
      elsif options[:resolv] == true or
        options[:resolv] == :dirty && is_dirty(record)
        if !getaddress(uri.host)
          "does not seem to exist (#{uri.host} not found)"
        end
      end
    end
    record.errors.add(attribute, error_msg) if error_msg.present?
  rescue URI::InvalidURIError
    record.errors.add(attribute, "is invalid")
  end

  private
  def getaddress(host)
    Timeout.timeout(5) do
      Resolv::DNS.new.getaddress(host)
    end
  rescue Resolv::ResolvError
    nil
  end

  def is_dirty(record)
    if record.respond_to?(:changed?)
      record.changed?
    else
      false
    end
  end

end
