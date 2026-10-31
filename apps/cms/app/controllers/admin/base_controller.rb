module Admin
  # Wspólna baza panelu — wymaga zalogowania (przez concern Authentication
  # włączony w ApplicationController) i używa layoutu „admin".
  class BaseController < ApplicationController
    layout "admin"

    PER_PAGE = 25

    private

    # Prosta paginacja offsetowa. Ustawia @page/@total_pages/@total_count
    # i zwraca wycinek kolekcji dla bieżącej strony (?page=N).
    def paginate(scope, per_page: PER_PAGE)
      @total_count = scope.count
      @total_pages = [ (@total_count.to_f / per_page).ceil, 1 ].max
      @page = params[:page].to_i
      @page = 1 if @page < 1
      @page = @total_pages if @page > @total_pages
      scope.offset((@page - 1) * per_page).limit(per_page)
    end
  end
end
