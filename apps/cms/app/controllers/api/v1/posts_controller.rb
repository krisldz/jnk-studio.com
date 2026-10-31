module Api
  module V1
    class PostsController < BaseController
      # GET /api/v1/posts
      def index
        @posts = Post.published.ordered
                     .includes(:post_category, cover_attachment: :blob)
      end

      # GET /api/v1/posts/:slug
      def show
        @post = Post.published.find_by_translated_slug(params[:slug], I18n.locale)
        return head(:not_found) unless @post

        @post = Post.includes(:post_category, cover_attachment: :blob).find(@post.id)
      end
    end
  end
end
