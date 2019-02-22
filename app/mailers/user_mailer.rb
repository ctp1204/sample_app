class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("acc_acti")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("password_reset")
  end
end
