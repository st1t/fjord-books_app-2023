# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :avatar, attached: true, content_type: %w[image/jpeg image/png image/gif],
                     dimension: { width: 200, height: 200 }, size: { between: 1.kilobyte..1.megabytes }
end
