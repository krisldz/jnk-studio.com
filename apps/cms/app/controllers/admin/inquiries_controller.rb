module Admin
  class InquiriesController < BaseController
    before_action :set_inquiry, only: %i[show update destroy]

    def index
      @inquiries = Inquiry.recent
    end

    def show
      @inquiry.status_read! if @inquiry.status_new?
    end

    def update
      if Inquiry.statuses.key?(params[:status])
        @inquiry.update!(status: params[:status])
        redirect_to admin_inquiries_path, notice: "Zaktualizowano status zapytania."
      else
        redirect_to admin_inquiries_path, alert: "Nieznany status."
      end
    end

    def destroy
      @inquiry.destroy
      redirect_to admin_inquiries_path, notice: "Usunięto zapytanie."
    end

    private

    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end
  end
end
