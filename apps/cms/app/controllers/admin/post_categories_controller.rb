module Admin
  class PostCategoriesController < BaseController
    before_action :set_post_category, only: %i[edit update destroy]

    def index
      @post_categories = PostCategory.ordered
    end

    def new
      @post_category = PostCategory.new
    end

    def create
      @post_category = PostCategory.new(post_category_params)
      if @post_category.save
        redirect_to admin_post_categories_path, notice: "Kategoria utworzona."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @post_category.update(post_category_params)
        redirect_to admin_post_categories_path, notice: "Zmiany zapisane."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post_category.destroy
      redirect_to admin_post_categories_path, notice: "Kategoria usunięta.", status: :see_other
    end

    private

    def set_post_category
      @post_category = PostCategory.find(params[:id])
    end

    def post_category_params
      params.require(:post_category).permit(:name_pl, :name_en, :name_de, :slug_pl, :slug_en, :slug_de, :position)
    end
  end
end
