module Admin
  class PostsController < BaseController
    before_action :set_post, only: %i[edit update destroy publish]

    def index
      scope = Post.ordered.includes(:post_category)
      if params[:q].present?
        q = "%#{params[:q].strip}%"
        scope = scope.where("title->>'pl' ILIKE :q OR title->>'en' ILIKE :q OR title->>'de' ILIKE :q", q: q)
      end
      scope = scope.where(post_category_id: params[:category_id]) if params[:category_id].present?
      scope = scope.where(status: params[:status]) if Post.statuses.key?(params[:status])
      @posts = paginate(scope)
      @post_categories = PostCategory.ordered
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)
      if @post.save
        redirect_to admin_posts_path, notice: "Wpis utworzony."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: "Zmiany zapisane."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: "Wpis usunięty.", status: :see_other
    end

    # Szybkie przełączenie publikacji.
    def publish
      @post.update(status: @post.published? ? :draft : :published)
      redirect_to admin_posts_path, notice: "Status zaktualizowany."
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(
        :title_pl, :title_en, :title_de,
        :slug_pl, :slug_en, :slug_de,
        :lead_pl, :lead_en, :lead_de,
        :body_pl, :body_en, :body_de,
        :status, :post_category_id, :author, :reading_time,
        :featured, :position, :published_at, :cover,
        :cover_credit, :cover_credit_url
      )
    end
  end
end
