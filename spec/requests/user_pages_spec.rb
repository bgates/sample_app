require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    describe "signup page" do
      it { should have_content('Sign up') }
      it { should have_title(full_title 'Sign Up') }
    end
  end

  describe "signing up" do
    before { visit signup_path }
    let(:submit) { 'Create my account' }

    describe "with valid information" do

      before { enter_valid_signup_info }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should show_logged_in(user) }
        it { should have_success_message('Welcome') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_signin_link }
        end
      end
    end

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title(full_title 'Sign Up') }
        it { should show_errors }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end
