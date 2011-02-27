class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  
  def index
    @title = "All users"
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @posts = @user.posts
    @new_post = Post.new if signed_in?
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      #UserMailer.deliver_registration_confirmation(@user)
      sign_in @user, "0"
      flash[:success] = "Welcome to Richard's Demo"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit your profile"
  end
  
  def update
    if @user.has_password?(params[:user][:password]) 
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile Updated."
        redirect_to @user
      else
        @title = "Edit your profile"
        render 'edit'
      end
    else
      flash.now[:error] = "Invalid email/password combination"
      @title = "Edit your profile"
      render 'edit'       
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end
  
  private 
  
  def admin_user
    if !current_user.admin?
      flash[:error] = "You do not have administrative privileges"
      redirect_to users_path
    else
      return true
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    if !current_user?(@user)
      flash[:error] = "You do not have permission to access this page"
      redirect_to(root_path)
    end 
  end

end
