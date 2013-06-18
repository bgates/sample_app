require 'spec_helper'

describe "Authentication" do
  
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "sign in" do

    describe "with invalid information" do
      before do
        visit signin_path
        click_button "Sign in"
      end
      
      it { should have_content('Sign in') }
      it { should have_error_message('Invalid') }
      it { should_not have_link("Users") }
      it { should_not have_link("Profile") }
      it { should_not have_link("Settings") }

      describe "after visiting another page" do
        before { click_link "Home" }

        it { should_not have_error_message }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }

      before { valid_signin(user) }
    
      it { should show_logged_in(user) }
      it { should have_link("Users", href: users_path) }
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link("Settings", href: edit_user_path(user)) }
      it { should_not have_signin_link }

    end
  end

  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create :user }

      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting the edit form" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do
            it "should render the desired protected page" do
              expect(page).to have_title('Edit user')
            end
          end
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
          
        end
      end
    end
    
    describe "as someone else" do
      let(:user) { FactoryGirl.create :user }
      let(:someone_else) { FactoryGirl.create :user, email: 'other@example.com' }

      before { valid_signin(user) }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(someone_else) }
        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to Users#update" do
        before { patch user_path(someone_else) }
        specify { expect(response).to redirect_to(signin_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create :user }
      let(:non_admin) { FactoryGirl.create :user }

      before { valid_signin non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
