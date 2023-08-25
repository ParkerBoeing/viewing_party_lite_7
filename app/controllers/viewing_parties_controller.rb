class ViewingPartiesController < ApplicationController

  def new
    
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User successfully created.'
      redirect_to user_path(@user)
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end