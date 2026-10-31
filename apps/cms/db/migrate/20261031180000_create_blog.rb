class CreateBlog < ActiveRecord::Migration[8.1]
  def change
    create_table :post_categories do |t|
      t.jsonb :name, null: false, default: {}
      t.jsonb :slug, null: false, default: {}
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :post_categories, :position

    create_table :posts do |t|
      t.jsonb :slug,  null: false, default: {}
      t.jsonb :title, null: false, default: {}
      t.jsonb :lead,  null: false, default: {}
      t.jsonb :body,  null: false, default: {}
      t.string :author
      t.integer :reading_time
      t.references :post_category, foreign_key: true
      t.boolean :featured, null: false, default: false
      t.integer :position, null: false, default: 0
      t.string :status, null: false, default: "draft"
      t.datetime :published_at

      t.timestamps
    end
    add_index :posts, :slug, using: :gin
    add_index :posts, :status
    add_index :posts, :featured
    add_index :posts, :position
    add_index :posts, :published_at
  end
end
