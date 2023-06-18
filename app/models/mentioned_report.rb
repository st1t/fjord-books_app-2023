# frozen_string_literal: true

class MentionedReport < ApplicationRecord
  has_many :report_mentioned_reports, dependent: :destroy
  has_many :reports, through: :report_mentioned_reports
end
