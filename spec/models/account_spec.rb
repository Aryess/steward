require 'spec_helper'

describe Account do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @account = user.accounts.build(login: "redd", provider: "test",
      token: "zrze", uid: "blaaa", jsondump: "{blabla}")
  end

  subject { @account }

  it { should respond_to(:login) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:provider) }
  it { should respond_to(:token)}
  it { should respond_to(:aux_token)}
  it { should respond_to(:expiresat)}
  it { should respond_to(:uid)}
  it { should respond_to(:stale?)}
  it { should respond_to(:jsondump)}
  its(:user) { should eq user }
  it { should respond_to(:contacts)}
  describe "when user_id is not present" do
    before { @account.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank login" do
    before { @account.login = " " }
    it { should_not be_valid }
  end

  describe "with blank provider" do
    before { @account.provider = " " }
    it { should_not be_valid }
  end

  describe "with blank token" do
    before { @account.token = " " }
    it { should_not be_valid }
  end

  describe "with blank aux_token" do
    before { @account.aux_token = " " }
    it { should be_valid }
  end

  describe "with blank expires_at" do
    before { @account.expiresat = " " }
    it { should be_valid }
  end

  describe "with blank uid" do
    before { @account.uid = " " }
    it { should_not be_valid }
  end

  describe "should be stale when token expires" do
    before { @account.expiresat = DateTime.now - 2.minutes }
    it { should be_stale}
  end

  describe "should not be stale when token is in the future" do
    before { @account.expiresat = DateTime.now + 2.minutes }
    it { should_not be_stale}
  end

  describe "should be ok for other user" do
    let(:other_user) { FactoryGirl.create(:user)}
    before do
      other_acc = other_user.accounts.build(login: "redd", provider: "test",
    token: "zrze", uid: "blaaa")
      other_acc.save
    end
    it { should be_valid}

    describe "it should be unique per user" do
      before { @account.dup.save}
      it { should_not be_valid}

    end
  end

  describe "should always have jsondump" do
    before { @account.jsondump = ""}
    it { should_not be_valid}
  end
end
