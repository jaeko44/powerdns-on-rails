require 'spec_helper'

describe TXT do
  context "when new" do

    it "should be invalid by default" do
      subject.should_not be_valid
    end

    it "should require content" do
      subject.should have(1).error_on(:content)
    end

    it "should not tamper with content" do
      subject.content = %Q{"google.com"}
      subject.content.should eql(%Q{"google.com"})
    end
  end
end
