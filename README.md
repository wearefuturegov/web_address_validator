# web_address_validator

https://github.com/thickpaddy/web_address_validator

## Description

An active model validator for web addresses.

Checks for a valid HTTP or HTTPS URL, and a host name with a DNS record.

## Installation

Add to `Gemfile` and bundle install:

    $ echo "gem 'web_address_validator', :git => 'git://github.com/thickpaddy/web_address_validator.git'" >> Gemfile
    $ bundle install

## Usage

Web address validation with default options:

    validates :model_attribute, :web_address => true

With DNS resolution disabled:

    validates :model_attribute, :web_address => { :resolv => false }

Default options for all instances can also be set using the default_options
class accessor:

    WebAddressValidator.default_options.merge!(:resolv => false)
