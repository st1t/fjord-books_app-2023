# frozen_string_literal: true

class Report < ApplicationRecord
  before_destroy :destroy_related_reports
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :report_mentioning_reports, dependent: :destroy
  has_many :mentioning_reports, through: :report_mentioning_reports

  has_many :report_mentioned_reports, dependent: :destroy
  has_many :mentioned_reports, through: :report_mentioned_reports

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def destroy_related_reports
    mentioning_reports.each(&:destroy)
    mentioned_reports.each(&:destroy)
  end
end
