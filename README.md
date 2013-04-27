# web_address_validator

https://github.com/thickpaddy/web_address_validator

## Description

An active model validator for web addresses.

Checks for a valid HTTP or HTTPS URL, and a host name with a DNS record.

To avoid records becoming invalid without being changed, DNS resolution is only
enabled for dirty records by default.

## Installation

Add to `Gemfile` and bundle install:

    $ echo "gem 'web_address_validator', :git => 'git://github.com/thickpaddy/web_address_validator.git'" >> Gemfile
    $ bundle install

## Usage

Web address validation with default options:

    validates :model_attribute, :web_address => true

DNS resolution is enabled or disabled by setting the resolv option to true or
false. The default is :dirty, i.e. only resolve host names for dirty records.

Setting the DNS resolution option per instance:

    validates :model_attribute, :web_address => { :resolv => false }

Change the default value for the DNS resolution option for all instances:

    WebAddressValidator.default_options.merge!(:resolv => false)
