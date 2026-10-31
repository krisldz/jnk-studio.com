module Admin
  # Wspólna baza panelu — wymaga zalogowania (przez concern Authentication
  # włączony w ApplicationController) i używa layoutu „admin".
  class BaseController < ApplicationController
    layout "admin"
  end
end
