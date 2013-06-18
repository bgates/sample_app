class UsersController < ApplicationController

  before_action :find_user, only: [ :show, :edit, :update, :destroy ]
  before_action :signed_in_user, only: [ :index, :edit, :update ]
  before_action :authorize_user, only: [ :edit, :update ]
  before_action :admin_user, only: :destroy
  before_action :no_signed_in, only: [ :new, :create ]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to @user, flash: { success: 'Welcome to the Sample App!' }
    else
      render :new     
    end
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes user_params
      sign_in @user
      redirect_to @user, flash: { success: 'That worked.' }
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def find_user
      @user = User.find(params[:id])
    end

    def authorize_user
      unless current_user?(@user)
        store_location
        redirect_to signin_url, notice: 'Please sign in.' 
      end
    end

    def admin_user
      redirect_to root_path unless current_user.admin? && !current_user?(@user)
    end

    def no_signed_in
      redirect_to root_path if signed_in?
    end
end
