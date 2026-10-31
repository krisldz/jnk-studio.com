module Admin
  class DashboardController < BaseController
    def index
      @projects_count = Project.count
      @published_count = Project.published.count
      @draft_count = Project.draft.count
      @categories_count = Category.count
      @posts_count = Post.count
      @posts_published_count = Post.published.count
      @new_inquiries_count = Inquiry.status_new.count
      @recent_projects = Project.ordered.limit(6)
    end
  end
end
