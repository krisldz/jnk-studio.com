module Admin
  class ProjectsController < BaseController
    before_action :set_project, only: %i[edit update destroy publish]

    def index
      scope = Project.ordered.includes(:category)
      if params[:q].present?
        q = "%#{params[:q].strip}%"
        scope = scope.where("title->>'pl' ILIKE :q OR title->>'en' ILIKE :q OR title->>'de' ILIKE :q", q: q)
      end
      scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
      scope = scope.where(status: params[:status]) if Project.statuses.key?(params[:status])
      scope = scope.where(featured: true) if params[:featured].present?
      @projects = paginate(scope)
      @categories = Category.ordered
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
        :title_pl, :title_en, :title_de,
        :slug_pl, :slug_en, :slug_de,
        :lead_pl, :lead_en, :lead_de,
        :body_pl, :body_en, :body_de,
        :status, :category_id, :year, :location, :area_m2,
        :featured, :position, :cover
      )
    end
  end
end
