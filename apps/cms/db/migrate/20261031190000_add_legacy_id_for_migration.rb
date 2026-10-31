class AddLegacyIdForMigration < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :legacy_id, :integer
    add_column :post_categories, :legacy_id, :integer
    add_column :projects, :legacy_id, :integer
    add_column :posts, :legacy_id, :integer
    add_column :project_images, :legacy_id, :integer

    add_index :categories, :legacy_id, unique: true
    add_index :post_categories, :legacy_id, unique: true
    add_index :projects, :legacy_id, unique: true
    add_index :posts, :legacy_id, unique: true
    add_index :project_images, :legacy_id, unique: true
  end
end
