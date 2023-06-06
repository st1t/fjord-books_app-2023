# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  # GET /reports
  def index
    @reports = Report.all.page(params[:page])
  end

  # GET /reports/1
  def show
    @comment = Comment.new
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit; end

  # POST /reports
  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reports/1
  def update
    @report = my_report
    if @report.nil?
      redirect_to reports_url, alert: t('controllers.common.error_not_owner_update', name: Report.model_name.human)
    elsif @report.update(report_params)
      redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reports/1
  def destroy
    @report = my_report
    if @report.nil?
      redirect_to reports_url, alert: t('controllers.common.error_not_owner_destroy', name: Report.model_name.human)
    else
      @report.destroy
      redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  def my_report
    current_user.reports.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :body).merge(user_id: current_user.id)
  end
end
