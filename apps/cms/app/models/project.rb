class Project < ApplicationRecord
  include Translatable
  translates :slug, :title, :lead, :body

  belongs_to :category, optional: true
  has_many :project_images, -> { order(position: :asc) }, dependent: :destroy
  has_one_attached :cover

  enum :status, { draft: "draft", published: "published", archived: "archived" },
       default: :draft

  scope :ordered, -> { order(featured: :desc, position: :asc, created_at: :desc) }

  validates :year, numericality: { only_integer: true, allow_nil: true }
  validates :area_m2, numericality: { only_integer: true, allow_nil: true }

  # Znajdź po slugu w danym języku, z fallbackiem do PL.
  def self.find_by_translated_slug(slug, locale)
    where("slug ->> ? = ?", locale.to_s, slug).first ||
      where("slug ->> ? = ?", I18n.default_locale.to_s, slug).first
  end

  # Slugi we wszystkich dostępnych językach — do hreflang i przełącznika języka.
  def slug_alternates
    slug_translations.slice(*I18n.available_locales.map(&:to_s))
  end
end
