class PostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "Post saved!"
      redirect_to user_path(current_user)
    else
      redirect_to root_path
    end
  end
  
  def destroy
    @post.destroy
    redirect_back_or user_path(current_user)
  end
  
  private
  
  def authorized_user
    @post = Post.find(params[:id])
    redirect_to root_path unless current_user?(@post.user)
  end
  
end
