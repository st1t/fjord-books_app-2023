# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]
  # GET /comments
  # def index
  #   @comments = Comment.order(:id).page(params[:page])
  # end

  # # GET /comments/1
  # def show
  #   @comment = Comment.new
  # end

  # # GET /comments/new
  def new
    @comment = Comment.new
  end

  # # GET /comments/1/edit
  # def edit; end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to comment_url(@comment), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  # def update
  #   if @comment.update(comment_params)
  #     redirect_to comment_url(@comment), notice: t('controllers.common.notice_update', name: Comment.model_name.human)
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  # DELETE /comments/1
  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to comments_url, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      redirect_to comments_url, alert: t('controllers.comments.error_not_owner')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:author, :body, :commentable_id, :commentable_type, :user_id)
  end
end
