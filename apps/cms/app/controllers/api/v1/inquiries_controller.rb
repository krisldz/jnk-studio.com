module Api
  module V1
    # Przyjmuje zapytania z formularza kontaktowego (SvelteKit server-side).
    class InquiriesController < BaseController
      def create
        inquiry = Inquiry.new(inquiry_params)
        inquiry.locale = I18n.locale.to_s

        if inquiry.save
          notify(inquiry)
          render json: { ok: true, id: inquiry.id }, status: :created
        else
          render json: { ok: false, errors: inquiry.errors.messages }, status: 422
        end
      end

      private

      def inquiry_params
        params.require(:inquiry).permit(
          :name, :email, :phone, :place, :inquiry_type, :message, :consent
        )
      end

      # Powiadomienie e-mail do pracowni. Zapis zapytania jest źródłem prawdy —
      # awaria kolejki/SMTP nie może przerwać żądania.
      def notify(inquiry)
        ContactMailer.notification(inquiry).deliver_later
      rescue StandardError => e
        Rails.logger.error("[inquiries] powiadomienie nieudane: #{e.class}: #{e.message}")
      end
    end
  end
end
