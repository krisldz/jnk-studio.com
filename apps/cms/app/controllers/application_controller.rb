class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  private

  def current_user
    Current.user
  end

  # Po zalogowaniu wracamy tam, skąd przyszliśmy, albo do panelu.
  def after_authentication_url
    session.delete(:return_to_after_authenticating) || admin_root_url
  end
end
