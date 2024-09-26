# frozen_string_literal: true

class MentioningReport < ApplicationRecord
  has_many :report_mentioning_reports, dependent: :destroy
  has_many :reports, through: :report_mentioning_reports

  validates :mentioner_report_id, uniqueness: { scope: :mentionee_report_id }
end
