class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.jsonb :name, null: false, default: {}
      t.jsonb :slug, null: false, default: {}
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :categories, :position
  end
end
