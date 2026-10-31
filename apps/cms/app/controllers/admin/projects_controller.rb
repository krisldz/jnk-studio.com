module Admin
  class ProjectsController < BaseController
    before_action :set_project, only: %i[edit update destroy publish]

    def index
      @projects = Project.ordered.includes(:category)
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)
      if @project.save
        redirect_to admin_projects_path, notice: "Realizacja utworzona."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @project.update(project_params)
        redirect_to admin_projects_path, notice: "Zmiany zapisane."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @project.destroy
      redirect_to admin_projects_path, notice: "Realizacja usunięta.", status: :see_other
    end

    # Szybkie przełączenie publikacji.
    def publish
      @project.update(status: @project.published? ? :draft : :published)
      redirect_to admin_projects_path, notice: "Status zaktualizowany."
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(
        :title_pl, :title_en,
        :slug_pl, :slug_en,
        :lead_pl, :lead_en,
        :body_pl, :body_en,
        :status, :category_id, :year, :location, :area_m2,
        :featured, :position, :cover
      )
    end
  end
end
