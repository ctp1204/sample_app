class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "success_acti"
      redirect_to user
    else
      flash[:danger] = t "inva_acti"
      redirect_to root_path
    end
  end
end
