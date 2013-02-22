require 'spec_helper'

# TODO: test for specific error messages

describe WebAddressValidator do

  context "bad uri" do
    subject { TestModel.new("%") }
    it { should_not be_valid }
  end

  context "no host name" do
    subject { TestModel.new("http://") }
    it { should_not be_valid }
  end

  context "known host" do

    let(:known_host) { "google.com" }

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

end
