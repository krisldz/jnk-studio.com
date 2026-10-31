module Admin
  class DashboardController < BaseController
    def index
      @projects_count = Project.count
      @published_count = Project.published.count
      @draft_count = Project.draft.count
      @categories_count = Category.count
      @new_inquiries_count = Inquiry.status_new.count
      @recent_projects = Project.ordered.limit(6)
    end
  end
end
