# Zapytanie z formularza kontaktowego (publiczne API → panel).
class Inquiry < ApplicationRecord
  # Rodzaje zgodne z chipami w formularzu (apps/web /kontakt).
  TYPES = %w[dom wn usl kon inne].freeze

  # prefix: true → scope'y status_new / status_read / status_archived,
  # bez kolizji z Inquiry.new.
  enum :status, { new: "new", read: "read", archived: "archived" },
       default: :new, prefix: true

  validates :name, presence: true, length: { maximum: 120 }
  validates :email, presence: true,
                    length: { maximum: 160 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :message, length: { maximum: 5000 }
  validates :inquiry_type, inclusion: { in: TYPES }, allow_blank: true
  validates :consent, inclusion: { in: [ true ], message: "jest wymagana" }

  scope :recent, -> { order(created_at: :desc) }

  def type_label
    I18n.t("inquiry.types.#{inquiry_type}", default: inquiry_type.to_s.presence || "—")
  end
end
