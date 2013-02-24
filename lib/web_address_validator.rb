require 'uri'
require 'resolv'

# TODO:
# - locale file for error messages
# - short timeout for dns resolution
# - decide how to handle errors due to unreachable name server
# - allow default options to be configured in initializer

class WebAddressValidator < ActiveModel::EachValidator

  def initialize(options)
    options.reverse_merge!(:resolv => true)
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
      elsif options[:resolv] && !getaddress(uri.host)
        "does not seem to exist (#{uri.host} not found)"
      end
    end
    record.errors.add(attribute, error_msg) if error_msg.present?
  rescue URI::InvalidURIError
    record.errors.add(attribute, "is invalid")
  end

  private
  def getaddress(host)
    Resolv::DNS.new.getaddress(host)
  rescue Resolv::ResolvError
    nil
  end

end
