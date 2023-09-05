class UsersController < ApplicationController
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
    if params[:user][:password] == params[:user][:confirm_password]
      @user = User.new(user_params)
      if @user.save
        flash[:success] = "Welcome, #{@user.name}!"
        redirect_to user_path(@user)
      else
        flash.now[:error] = @user.errors.full_messages.to_sentence
        render 'new'
      end
    else
      flash.now[:error] = "Passwords do not match"
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

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end