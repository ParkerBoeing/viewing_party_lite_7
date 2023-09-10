class UsersController < ApplicationController
  before_action :require_login, only: [:show]
  def show
    @user = User.find(params[:id])
  end

  def discover
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}!"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.name}!"
        redirect_to user_path(user)
      else
        flash[:error] = "Sorry, your credentials are bad."
        render :login_form
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'You have successfully logged out.'
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in or registered to access the dashboard."
      redirect_to root_path
    end
  end

  def logged_in?
    session[:user_id]
  end
end