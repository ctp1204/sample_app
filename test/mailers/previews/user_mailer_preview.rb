class UserMailerPreview < ActionMailer::Preview
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  def password_reset
    UserMailer.password_reset
  end
end
