class UsersController < ApplicationController
  before_action :ensure_signed_out, only: [:new, :create]
  before_action :ensure_signed_in, only: [:show, :account]

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)
    if User.where(:username => @user.username).blank? == false
      flash[:error] = 'User name already present'
      redirect_to action: 'new'      
    elsif @user.save
      sign_in(@user)
      flash[:notice] = 'Welcome to the MyInvestMentWiki-App'
      redirect_to :root
    else 
      flash[:error] = @user.errors.full_messages.join(', ')
      redirect_to action:'new'
    end
  end

  def account
    @user = current_user
  end

  private

  def create_user_params
    params.require(:user).permit(:username, :password, :email, :last_name, :first_name)
  end
end