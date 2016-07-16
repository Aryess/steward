require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:accounts) }

  it {should be_valid}
  it {should_not be_admin}

  describe "Name" do
    describe "When not present" do
      before {@user.name = " "}
      it {should_not be_valid}
    end

    describe "When too long" do
      before { @user.name = "a" * 51 }
      it { should_not be_valid }
    end

    describe "When has incorrect char" do
      it "should be invalid" do
        names = ["use\"uoo", "zz(ehrzer", "ger_ur", "ur$zr", "zerree4e", "utr<rt"]
        names.each do |invalid_name|
          @user.name = invalid_name
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when irish" do
      before {@user.name = "Mc M'achin-truc"}
      it { should be_valid}
    end
  end

  describe "email" do
    describe "When not present" do
      before {@user.email = " "}
      it {should_not be_valid}
    end

    describe "When too long" do
      before {@user.email = "a"*255 + "@gmail.com"}
      it {should_not be_valid}
    end

    describe "when format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar+baz.com user@mail.ongtf test@free..fr]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.co.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    describe "when not unique" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.name = @user.name + "change"
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end
      it { should_not be_valid }
    end
  end

  describe "password" do
    describe "when not present" do
      before { @user = User.new(
        name:   "Alfred Dupond",
        email:  "alfred.dupond@gmail.com",
        password: " ",
        password_confirmation: " "
        )
      }
      it { should_not be_valid }
    end

    describe "when does not match " do
      before { @user.password_confirmation = @user.password + "nope" }
      it {should_not be_valid}
    end

    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end

    describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by(email: @user.email) }

      describe "with valid password" do
        it { should eq found_user.authenticate(@user.password) }
      end

      describe "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }

        it { should_not eq user_for_invalid_password }
        specify { expect(user_for_invalid_password).to be_false }
      end
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "accounts association" do
    before { @user.save }
    let!(:older_account) do
      FactoryGirl.create(:account, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_account) do
      FactoryGirl.create(:account, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right accounts in the right order" do
      expect(@user.accounts.to_a).to eq [older_account, newer_account]
    end

    it "should destroy associated accounts" do
      accounts = @user.accounts.to_a
      @user.destroy
      expect(accounts).not_to be_empty
      accounts.each do |account|
        expect(Account.where(id: account.id)).to be_empty
      end
    end
  end
end