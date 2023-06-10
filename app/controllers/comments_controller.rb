# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]
  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to comment_url(@comment), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to comments_url, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  rescue ActiveRecord::RecordNotFound
    redirect_to comments_url, alert: t('controllers.common.error_not_owner_destroy', name: Comment.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:author, :body, :commentable_id, :commentable_type).merge(user_id: current_user.id)
  end
end
