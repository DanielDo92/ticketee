require 'rails_helper'

RSpec.feature "Admin can manage a user's role" do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:user) { FactoryGirl.create(:user) }

  let!(:ie) { FactoryGirl.create(:project, name: "Internet Explorer") }
  let!(:st3) { FactoryGirl.create(:project, name: "Sublime Text 3") }

  before do
    login_as(admin)
  end

  scenario "when assigning role to a new user" do
    visit new_admin_user_path

    fill_in "Email", with: "newuser@ticketee.com"
    fill_in "Password", with: "password"

    select "Editor", from: "Internet Explorer"
    click_button "Create User"

    click_link "newuser@ticketee.com"
    expect(page).to have_content "Internet Explorer: Editor"
    expect(page).not_to have_content "Sublime Text 3"

  end

  scenario "when assigning role to an existing user" do
    visit admin_user_path(user)
    click_link "Edit User"

    select "Manager", from: "Sublime Text 3"
    select "Viewer", from: "Internet Explorer"

    click_button "Update User"
    expect(page).to have_content "User has been updated"

    click_link user.email
    expect(page).to have_content "Internet Explorer: Viewer"
    expect(page).to have_content "Sublime Text 3: Manager"
  end
end