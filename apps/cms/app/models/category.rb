class Category < ApplicationRecord
  include Translatable
  translates :name, :slug

  has_many :projects, dependent: :nullify

  scope :ordered, -> { order(position: :asc) }
end
