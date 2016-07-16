require 'spec_helper'

describe Contact do
  let(:account) { FactoryGirl.create(:account) }
  before do
    @contact = account.contacts.build(name: "Toto", external_id: "fb_id")
  end

  subject { @contact }

  it { should respond_to(:name) }
  it { should respond_to(:external_id) }
  it { should respond_to(:account_id) }
  it { should respond_to(:deleted) }
  it { should respond_to(:archived) }
  it { should respond_to(:account) }
  its(:account) { should eq account }

  it { should be_valid }

  describe "when account_id is not present" do
    before { @contact.account_id = nil }
    it { should_not be_valid }
  end

  describe "default values" do
    its(:deleted) { should eq false }
    its(:archived) { should eq false }
  end
end
