require 'spec_helper'

describe "Static pages" do
  subject {page}
  let(:base_title) { "Steward" }

  describe "Home page" do
    before {visit root_path}

    it { should have_content("#{base_title}") }
    it { should have_content(%r{#{'social media'}}i)}
    it { should have_title(full_title("Home"))}
  end

  describe "Help page" do
    before {visit help_path}

    it {should have_content('Help')}
    it {should have_title(full_title("Help"))}
  end

  describe "Dashboard" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit dashboard_path
    end

    it {should have_content('My dashboard')}
    it {should have_title(full_title("Dashboard"))}
  end

end