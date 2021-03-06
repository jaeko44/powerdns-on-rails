require 'spec_helper'

describe SOA do
  context "when new" do

    it "should be invalid by default" do
      subject.should_not be_valid
    end

    it "should be unique per domain" do
      subject.domain = FactoryGirl.create(:domain)
      subject.should have(1).error_on(:domain_id)
    end

    it "should require a primary NS" do
      subject.should have(1).error_on(:primary_ns)
    end

    it "should require a contact" do
      subject.should have(1).error_on(:contact)
    end

    it "should require a valid email address for the contact" do
      subject.contact = 'test'
      subject.should have(1).error_on(:contact)

      subject.contact = 'test@example'
      subject.should have(1).error_on(:contact)

      subject.contact = 'test@example.com'
      subject.should have(:no).errors_on(:contact)
    end

    it "should flip the first period in the contact to an @" do
      subject.contact = 'test.example.com'
      subject.contact.should == 'test@example.com'

      subject.contact = 'test@example.com'
      subject.contact.should == 'test@example.com'
    end

    it "should have an autogenerated serial" do
      subject.serial.should_not be_nil
    end

    it "should only accept positive integers as serials" do
      subject.serial = -2008040101
      subject.should have(1).error_on(:serial)

      subject.serial = 'ISBN123456789'
      subject.should have(1).error_on(:serial)

      subject.serial = 2008040101
      subject.should have(:no).errors_on(:serial)
    end

    it "should require a refresh time" do
      subject.should have(1).error_on(:refresh)
    end

    it "should only accept positive integers as refresh time" do
      subject.refresh = -86400
      subject.should have(1).error_on(:refresh)

      subject.refresh = '12h'
      subject.should have(1).error_on(:refresh)

      subject.refresh = 2008040101
      subject.should have(:no).errors_on(:refresh)
    end

    it "should require a retry time" do
      subject.should have(1).error_on(:retry)
    end

    it "should only accept positive integers as retry time" do
      subject.retry = -86400
      subject.should have(1).error_on(:retry)

      subject.retry = '15m'
      subject.should have(1).error_on(:retry)

      subject.retry = 2008040101
      subject.should have(:no).errors_on(:retry)
    end

    it "should require a expiry time" do
      subject.should have(1).error_on(:expire)
    end

    it "should only accept positive integers as expiry times" do
      subject.expire = -86400
      subject.should have(1).error_on(:expire)

      subject.expire = '2w'
      subject.should have(1).error_on(:expire)

      subject.expire = 2008040101
      subject.should have(:no).errors_on(:expire)
    end

    it "should require a minimum time" do
      subject.should have(1).error_on(:minimum)
    end

    it "should only accept positive integers as minimum times" do
      subject.minimum = -86400
      subject.should have(1).error_on(:minimum)

      subject.minimum = '3h'
      subject.should have(1).error_on(:minimum)

      subject.minimum = 10800
      subject.should have(:no).errors_on(:minimum)
    end

    it "should not allow a minimum of more than 10800 seconds (RFC2308)" do
      subject.minimum = 84600
      subject.should have(1).error_on(:minimum)
    end

  end

  context "when created" do
    before(:each) do
      @domain = FactoryGirl.create(:domain)
      @domain.soa_record.destroy

      @soa = SOA.new(
        :domain => @domain,
        :primary_ns => 'ns1.example.com',
        :contact => 'dnsadmin@example.com',
        :refresh => 7200,
        :retry => 1800,
        :expire => 604800,
        :minimum => 10800
      )
    end

    it "should have the convenience fields populated before save" do
      @soa.primary_ns.should eql('ns1.example.com')
    end

    it "should create a content field from the convenience fields" do
      @soa.save.should be_true

      @soa.content.should match(/ns1\.example\.com dnsadmin@example.com \d+ 7200 1800 604800 10800/)
    end

  end

  context "serial numbers" do
    before(:each) do
      @soa = FactoryGirl.create(:domain).soa_record
    end

    it "should have an easy way to update (without saving)" do
      serial = @soa.serial
      serial.should_not be_nil

      @soa.update_serial

      @soa.serial.should_not be( serial )
      @soa.serial.should >( serial )

      @soa.reload
      @soa.serial.should eql( serial )
    end

    it "should have an easy way to update (with saving)" do
      serial = @soa.serial
      serial.should_not be_nil

      @soa.update_serial!

      @soa.serial.should_not be( serial )
      @soa.serial.should >( serial )

      @soa.reload
      @soa.serial.should_not be( serial )
    end

    it "should update in sequence for the same day" do
      date_segment = Time.now.strftime( "%Y%m%d" )

      @soa.serial.to_s.should eql( date_segment + '00' )

      10.times { @soa.update_serial! }

      @soa.serial.to_s.should eql( date_segment + '10' )
    end
  end

  context "when serializing to XML" do
    before(:each) do
      @soa = FactoryGirl.create(:domain).soa_record
    end

    it "should make an soa tag" do
      @soa.to_xml.should match(/<soa>/)
    end

    it "should have the custom soa attributes present" do
      xml = @soa.to_xml

      xml.should match(/<primary\-ns/)
      xml.should match(/<contact/)
      xml.should match(/<serial/)
      xml.should match(/<minimum/)
      xml.should match(/<expire/)
      xml.should match(/<refresh/)
      xml.should match(/<retry/)
    end

    it "should preserve original #to_xml options" do
      xml = @soa.to_xml :skip_instruct => true
      xml.should_not match(/<\?xml/)
    end
  end
end
