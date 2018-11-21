class JobPostsController < ApplicationController

  before_action :authenticate_user!, only: [ :new, :create, :destroy, :update ]

  def new 
    @job_post = JobPost.new
  end

  def create
    @job_post = JobPost.new job_post_params
    @job_post.user = current_user

    if @job_post.save
      flash[:success] = "Success!"
      redirect_to job_posts_path(@job_post)
    else
      render :new
    end
  end

  def show
    @job_post = JobPost.find params[:id]
  end

  def destroy
    @job_post = JobPost.find params[:id]
    
    if can?(:delete, @job_post)
      @job_post.destroy
      redirect_to job_posts_path
    else
      redirect_to job_post_path(@job_post)
    end
  end

  def update
    @job_post = JobPost.find params[:id]
    @job_post.update(job_post_params)
  end



  private

  def job_post_params
    params
      .require(:job_post)
      .permit(:title, :description, :company, :min_salary, :max_salary)
  end
end
