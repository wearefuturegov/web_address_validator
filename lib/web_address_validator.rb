require 'uri'

# TODO: locale file for error messages

class WebAddressValidator < ActiveModel::EachValidator

  def validate_each(record, attr, value)
    uri = URI.parse(value)
    if uri.scheme.nil?
      record.errors.add(attr, "is missing protocol (e.g. http://)")
    elsif uri.scheme != "http" && uri.scheme != "https"
      record.errors.add(attr, "specifies unsupported protocol, '#{uri.scheme}'")
    elsif uri.host.nil?
      record.errors.add(attr, "is missing host name (e.g. www.google.com)")
    end
  rescue URI::InvalidURIError
    record.errors.add(attr, "is invalid")
  end

end
