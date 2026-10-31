class PostCategory < ApplicationRecord
  include Translatable
  translates :name, :slug

  has_many :posts, dependent: :nullify

  scope :ordered, -> { order(position: :asc) }
end
