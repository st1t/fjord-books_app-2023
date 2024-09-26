# frozen_string_literal: true

class ReportMentionedReport < ApplicationRecord
  belongs_to :report
  belongs_to :mentioned_report

  validates :report_id, uniqueness: { scope: :mentioned_report_id }
end
