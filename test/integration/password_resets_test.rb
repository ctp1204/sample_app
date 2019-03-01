require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users :dat
  end

  test "password resets if invalid and valid email" do
    get new_password_reset_path
    assert_template "password_resets/new"
    # Invalid email
    post password_resets_path, params: {password_reset: {email: ""}}
    assert_not flash.empty?
    assert_template "password_resets/new"
    # Valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "password reset if inactive user" do
    get new_password_reset_path
    post password_resets_path, params: {password_reset: {email: @user.email}}
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to new_password_reset_path
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_path
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "foobaz",
                      password_confirmation: "barquux"}}
    assert_select "div#error_explanation"
    # Empty password
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "",
                      password_confirmation: ""}}
    assert_select "div#error_explanation"
  end

  test "password reset if valid password and confirmation" do
    post password_resets_path, params: {password_reset: {email: @user.email}}
    # Password reset form
    user = assigns :user
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
               user: {password: "foobaz",
                      password_confirmation: "foobaz"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
