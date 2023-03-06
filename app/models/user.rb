# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :avatar, attached: true, content_type: %w[image/jpg image/png image/gif]
end
