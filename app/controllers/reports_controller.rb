# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])

    @mentioned_reports = []
    @report.mentioned_reports.each do |mentioned_report|
      user_name = Report.find(mentioned_report.mentioner_report_id).user.name
      title = "#{Report.find(mentioned_report.mentioner_report_id).title} by #{user_name}"
      path = report_path(mentioned_report.mentioner_report_id)
      @mentioned_reports << { title:, path: }
    end
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
      mention_create!
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    rescue StandardError
      render :new, status: :unprocessable_entity
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @report.update!(report_params)
      @report.mentioned_reports.delete_all
      mention_update!
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

  def mention_create!
    mentioning_report_ids = mentioning_report_ids(@report.content)
    mentioning_report_ids.each do |id|
      mentioning_report = MentioningReport.create!(mentioner_report_id: @report.id, mentionee_report_id: id)
      @report.mentioning_reports << mentioning_report

      mentioned_report = MentionedReport.create!(mentioner_report_id: @report.id, mentionee_report_id: id)
      report = Report.find(id)
      report.mentioned_reports << mentioned_report
    end
  end

  def mention_update!
    mentioning_report_ids = mentioning_report_ids(@report.content)
    mentioning_report_ids.each do |id|
      mentioning_report = MentioningReport.find_or_create_by!(mentioner_report_id: @report.id, mentionee_report_id: id)
      @report.mentioning_reports << mentioning_report unless @report.mentioning_reports.exists?(mentioning_report.id)

      report = Report.find(id)
      mentioned_report = MentionedReport.find_or_create_by!(mentioner_report_id: @report.id, mentionee_report_id: id)
      report.mentioned_reports << mentioned_report unless report.mentioned_reports.exists?(mentioned_report.id)
    end
  end
end
