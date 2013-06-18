include ApplicationHelper

def valid_signin(user)
  visit signin_path
  fill_in "Email", with: user.email.upcase
  fill_in "Password", with: user.password
  click_button "Sign in"
  cookies[:remember_token] = user.remember_token
end

def enter_valid_signup_info
  fill_in "Name", with: "Example User"
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
end

RSpec::Matchers.define :have_error_message do |msg|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: msg)
  end
end

RSpec::Matchers.define :have_success_message do |msg|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: msg)
  end
end

RSpec::Matchers.define :have_signin_link do |l|
  match do |page|
    expect(page).to have_link('Sign in', href: signin_path)
  end
end
                                                          
RSpec::Matchers.define :have_signout_link do |l|
  match do |page|
    expect(page).to have_link('Sign out', href: signout_path)
  end
end

RSpec::Matchers.define :show_errors do |l|
  match do |page|
    expect(page).to have_selector('#error_explanation')
  end
end

RSpec::Matchers.define :show_logged_in do |user|
  match do |page|
    expect(page).to have_signout_link
    expect(page).to have_title(user.name)
  end
end
