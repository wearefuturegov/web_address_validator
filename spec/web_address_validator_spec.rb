require 'spec_helper'

describe WebAddressValidator do

  subject { TestModel }

  it "should require a protocol" do
    subject.new("foo").should_not be_valid
  end

end
