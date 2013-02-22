# web_address_validator

https://github.com/thickpaddy/web_address_validator

## Description

An active model validator for web addresses that goes beyond simply ensuring the URL is valid.

## Installation

Add to `Gemfile` and bundle install:

    $ echo "gem 'web_address_validator', :git => 'git://github.com/thickpaddy/web_address_validator.git'" >> Gemfile
    $ bundle install

## Usage

    validates :model_attribute, :web_address => true
