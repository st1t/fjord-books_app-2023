# frozen_string_literal: true

class ReportMentionedReport < ApplicationRecord
  belongs_to :report
  belongs_to :mentioned_report
end
