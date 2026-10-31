class Post < ApplicationRecord
  include Translatable
  translates :slug, :title, :lead, :body

  belongs_to :post_category, optional: true
  has_one_attached :cover

  enum :status, { draft: "draft", published: "published", archived: "archived" },
       default: :draft

  # Wyróżnione najpierw, potem od najnowszych (published_at, fallback created_at).
  scope :ordered, lambda {
    order(featured: :desc)
      .order(Arel.sql("published_at DESC NULLS LAST"))
      .order(created_at: :desc)
  }

  validates :reading_time, numericality: { only_integer: true, greater_than: 0, allow_nil: true }

  before_save :ensure_published_at

  # Znajdź po slugu w danym języku, z fallbackiem do PL.
  def self.find_by_translated_slug(slug, locale)
    where("slug ->> ? = ?", locale.to_s, slug).first ||
      where("slug ->> ? = ?", I18n.default_locale.to_s, slug).first
  end

  # Slugi we wszystkich dostępnych językach — do hreflang i przełącznika języka.
  def slug_alternates
    slug_translations.slice(*I18n.available_locales.map(&:to_s))
  end

  # Szacowany czas czytania w minutach: ręczny, a jeśli pusty — liczony z treści
  # (~200 słów/min, minimum 1). Zwraca nil tylko dla pustej treści bez wartości.
  def reading_minutes(locale = I18n.locale)
    return reading_time if reading_time.present?

    text = ActionView::Base.full_sanitizer.sanitize(body(locale).to_s)
    words = text.split.size
    return nil if words.zero?

    [ (words / 200.0).ceil, 1 ].max
  end

  private

  # Przy pierwszej publikacji ustaw datę publikacji, jeśli nie podano ręcznie.
  def ensure_published_at
    self.published_at ||= Time.current if status == "published"
  end
end
