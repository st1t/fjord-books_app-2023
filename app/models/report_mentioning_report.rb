# frozen_string_literal: true

class ReportMentioningReport < ApplicationRecord
  belongs_to :report
  belongs_to :mentioning_report

  validates :report_id, uniqueness: { scope: :mentioning_report_id }
end
