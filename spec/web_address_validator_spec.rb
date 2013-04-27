require 'spec_helper'

# TODO:
# - test for specific error messages
# - test more known hosts; fqdns, second level domains etc.

describe WebAddressValidator do

  describe "options" do
    it "should allow defaults to be set for all instances" do
      klass = WebAddressValidator.dup
      klass.default_options = {:foo => :bar}
      klass.new(:attributes => {}).options.should include(:foo => :bar)
    end
    describe "resolv" do
      it "should be enabled for dirty records by default" do
        WebAddressValidator.new(:attributes => {}).options.should include(:resolv => :dirty)
      end
    end
  end

  let(:known_host) { "google.com" }
  let(:unknown_host) { "www.unknown-host-for-web-address-validator-spec.com" }

  let(:model) {
    Class.new(BaseModel) do
      validates :value, :web_address => true
    end
  }

  context "bad uri" do
    subject { model.new("%") }
    it { should_not be_valid }
  end

  context "no host name" do
    subject { model.new("http://") }
    it { should_not be_valid }
  end

  context "known host" do

    context "http protocol" do
      subject { model.new("http://#{known_host}") }
      it { should be_valid }
    end

    context "https protocol" do
      subject { model.new("https://#{known_host}") }
      it { should be_valid }
    end

    context "unsupported protocol (e.g. ftp)" do
      subject { model.new("ftp://#{known_host}") }
      it { should_not be_valid }
    end

    context "unknown protocol" do
      subject { model.new("foo://#{known_host}") }
      it { should_not be_valid }
    end

    context "missing protocol" do
      subject { model.new(known_host) }
      it { should_not be_valid }
    end

    context "invalidly formatted protocol element of url" do
      subject { model.new("http:/#{known_host}") }
      it { should_not be_valid }
    end

  end

  context "missing tld" do
    subject { model.new("http://foo") }
    it { should_not be_valid }
  end

  context "unknown host" do

    context "dns resolution enabled" do
      model = Class.new(BaseModel) do
        validates :value, :web_address => { :resolv => true }
      end
      subject { model.new("http://#{unknown_host}") }
      it { should_not be_valid }
    end

    context "dns resolution disabled" do
      model = Class.new(BaseModel) do
        validates :value, :web_address => { :resolv => false }
      end
      subject { model.new("http://#{unknown_host}") }
      it { should be_valid }
    end

    context "dns resolution enabled for dirty records" do
      before(:each) do
        model = Class.new(DirtyModel) do
          validates :value, :web_address => { :resolv => :dirty }
        end
        @object = model.new("http://#{unknown_host}")
      end

      it "should not be valid when changed" do
        @object.value = "foo"
        @object.should be_changed
        @object.should_not be_valid
      end

      it "should be valid when unchanged" do
        @object.should_not be_changed
        @object.should be_valid
      end
    end

  end

end
