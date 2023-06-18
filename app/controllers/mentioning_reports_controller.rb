class MentioningReportsController < ApplicationController
  before_action :set_mentioning_report, only: %i[destroy]

  def create; end

  def destroy
    @mentioning_report.destroy
  end

  private

  def set_mentioning_report
    @mentioning_report = current_user.mentioned_reports.find([:id])
  end
end
