require "rails_helper"

describe UsersController do
  render_views

  let!(:michael) { create(:michael) }
  let!(:archer) { create(:archer) }

  it "should get new" do
    visit signup_path
    expect(page).to have_http_status(:success)
    expect(page).to have_selector "title", exact_text: "Sign up | Ruby on Rails Tutorial Sample App", visible: false
  end

  it "should redirect edit when not logged in" do
    visit edit_user_path(michael)
    expect(current_path).to eq(login_path)
  end

  it "should redirect edit when logged in as wrong user" do
    log_in_as(archer)
    visit edit_user_path(michael)
    expect(page).not_to have_content "Please log in."
    expect(current_path).to eq(root_path)
  end

  it "should redirect index when not logged in" do
    visit users_path
    expect(current_path).to eq(login_path)
  end

  it "should redirect destroy when not logged in" do
    expect {
      page.driver.submit :delete, user_path(michael), {}
    }.to change { User.count }.by(0)
    expect(current_path).to eq(login_path)
  end

  it "should redirect destroy when logged in as a non-admin" do
    log_in_as(archer)
    expect {
      page.driver.submit :delete, user_path(michael), {}
    }.to change { User.count }.by(0)
    expect(current_path).to eq(root_path)
  end

  it "should redirect following when not logged in" do
    visit following_user_path(michael)
    expect(current_path).to eq(login_path)
  end

  it "should redirect followers when not logged in" do
    visit followers_user_path(michael)
    expect(current_path).to eq(login_path)
  end
end
