require 'spec_helper'

# TODO:
# - test for specific error messages
# - test more known hosts; fqdns, second level domains etc.

describe WebAddressValidator do

  describe "default options" do
    it "should allow defaults to be set at class level" do
      WebAddressValidator.default_options = {:foo => :bar}
      WebAddressValidator.new(:attributes => {}).options.should include(:foo => :bar)
    end
  end

  let(:known_host) { "google.com" }
  let(:unknown_host) { "www.unknown-host-for-web-address-validator-spec.com" }

  context "bad uri" do
    subject { TestModel.new("%") }
    it { should_not be_valid }
  end

  context "no host name" do
    subject { TestModel.new("http://") }
    it { should_not be_valid }
  end

  context "known host" do

    context "http protocol" do
      subject { TestModel.new("http://#{known_host}") }
      it { should be_valid }
    end

    context "https protocol" do
      subject { TestModel.new("https://#{known_host}") }
      it { should be_valid }
    end

    context "unsupported protocol (e.g. ftp)" do
      subject { TestModel.new("ftp://#{known_host}") }
      it { should_not be_valid }
    end

    context "unknown protocol" do
      subject { TestModel.new("foo://#{known_host}") }
      it { should_not be_valid }
    end

    context "missing protocol" do
      subject { TestModel.new(known_host) }
      it { should_not be_valid }
    end

    context "invalidly formatted protocol element of url" do
      subject { TestModel.new("http:/#{known_host}") }
      it { should_not be_valid }
    end

  end

  context "missing tld" do
    subject { TestModel.new("http://foo") }
    it { should_not be_valid }
  end

  context "unknown host" do

    context "dns resolution enabled" do
      subject { TestModel.new("http://#{unknown_host}") }
      it { should_not be_valid }
    end

    context "dns resolution disabled" do
      test_model = Class.new(ValidatableModel) do
        validates :value, :web_address => { :resolv => false }
      end
      subject { test_model.new("http://#{unknown_host}") }
      it { should be_valid }
    end

  end

end
