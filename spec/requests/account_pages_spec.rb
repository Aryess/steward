require 'spec_helper'

describe "Account Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "Account index" do
    let!(:acc1) { FactoryGirl.create(:account, user: user, login: "Foo") }
    let!(:acc2) { FactoryGirl.create(:account, user: user, login: "Bar") }
    before { visit accounts_path }

    it { should have_title('My accounts')}
    it { should have_content(user.name) }
    it { should have_content(acc1.login) }
    it { should have_content(acc2.login) }
    it { should have_content(user.accounts.count) }

    it "should be able to delete an account" do
      expect do
          first(".delete_link").click_link('', acc1)
        end.to change(Account, :count).by(-1)
      end

  end

end
