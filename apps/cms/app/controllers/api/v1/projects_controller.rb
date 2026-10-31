module Api
  module V1
    class ProjectsController < BaseController
      # GET /api/v1/projects
      def index
        @projects = Project.published.ordered
                           .includes(:category, cover_attachment: :blob)
      end

      # GET /api/v1/projects/:slug
      def show
        @project = Project.published.find_by_translated_slug(params[:slug], I18n.locale)
        return head(:not_found) unless @project

        @project = Project.includes(
          :category,
          cover_attachment: :blob,
          project_images: { image_attachment: :blob }
        ).find(@project.id)
      end
    end
  end
end
