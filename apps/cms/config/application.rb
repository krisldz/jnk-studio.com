require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # --- JNK Studio ---
    config.time_zone = "Warsaw"

    # Wielojęzyczność: PL domyślny, EN dodatkowy; fallback treści do PL.
    config.i18n.available_locales = %i[pl en]
    config.i18n.default_locale = :pl
    config.i18n.fallbacks = [ :pl ]

    # Warianty obrazów Active Storage przez libvips.
    config.active_storage.variant_processor = :vips
  end
end
