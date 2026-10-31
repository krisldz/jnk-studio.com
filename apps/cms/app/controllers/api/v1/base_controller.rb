module Api
  module V1
    # Wspólna baza publicznego API: tylko do odczytu, autoryzacja tokenem
    # serwisowym (SvelteKit server-side) i ustalenie języka odpowiedzi.
    class BaseController < ActionController::API
      before_action :set_locale
      before_action :authenticate_service!

      private

      # Token współdzielony FE↔BE. W dev (brak API_TOKEN) pomijamy, by ułatwić start.
      def authenticate_service!
        expected = ENV["API_TOKEN"].to_s
        return if expected.blank?

        provided = request.headers["Authorization"].to_s.delete_prefix("Bearer ")
        head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(provided, expected)
      end

      # Język: ?locale=xx → Accept-Language → PL. Nieznany → PL.
      def set_locale
        requested = params[:locale].presence || request.headers["Accept-Language"].to_s[0, 2]
        I18n.locale =
          if I18n.available_locales.map(&:to_s).include?(requested.to_s)
            requested
          else
            I18n.default_locale
          end
      end
    end
  end
end
