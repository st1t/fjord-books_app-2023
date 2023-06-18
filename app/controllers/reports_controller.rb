# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    ActiveRecord::Base.transaction do
      @report.save!
      mention_save!
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    rescue StandardError
      render :new, status: :unprocessable_entity
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @report.update!(report_params)
      mention_save!
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    rescue StandardError
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def mentioning_report_ids(report)
    report_ids = []
    regexp = URI::DEFAULT_PARSER.make_regexp(['http://localhost'])
    report.to_enum(:scan, regexp).map { Regexp.last_match }.each do |match|
      report_ids << match[7].gsub(%r{/reports/}, '').to_i
    end
    report_ids
  end

  def mention_save!
    mentioning_report_ids = mentioning_report_ids(@report.content)
    mentioning_report_ids.each do |id|
      mentioning_report = MentioningReport.create!(report_id: @report.id, mentioning_report_id: id)
      @report.mentioning_reports << mentioning_report

      mentioned_report = MentionedReport.create!(report_id: id, mentioned_report_id: @report.id)
      @report.mentioned_reports << mentioned_report
    end
  end
end
