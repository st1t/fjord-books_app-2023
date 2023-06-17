# frozen_string_literal: true

class MentioningReport < ApplicationRecord
  has_many :report_mentioning_reports, dependent: :destroy
  has_many :reports, through: :report_mentioning_reports
end
