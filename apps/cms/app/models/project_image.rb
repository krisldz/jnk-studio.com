class ProjectImage < ApplicationRecord
  include Translatable
  translates :alt

  belongs_to :project
  has_one_attached :image

  scope :ordered, -> { order(position: :asc) }
end
