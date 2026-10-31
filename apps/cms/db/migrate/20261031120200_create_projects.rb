class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.jsonb :slug, null: false, default: {}
      t.jsonb :title, null: false, default: {}
      t.jsonb :lead, null: false, default: {}
      t.jsonb :body, null: false, default: {}
      t.integer :year
      t.string :location
      t.integer :area_m2
      t.references :category, foreign_key: true, null: true
      t.boolean :featured, null: false, default: false
      t.integer :position, null: false, default: 0
      t.string :status, null: false, default: "draft"
      t.datetime :published_at

      t.timestamps
    end

    add_index :projects, :status
    add_index :projects, :featured
    add_index :projects, :position
    add_index :projects, :slug, using: :gin
  end
end
