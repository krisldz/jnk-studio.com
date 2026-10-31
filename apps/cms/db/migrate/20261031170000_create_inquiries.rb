class CreateInquiries < ActiveRecord::Migration[8.1]
  def change
    create_table :inquiries do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :place
      t.string :inquiry_type
      t.text :message
      t.boolean :consent, null: false, default: false
      t.string :locale, null: false, default: "pl"
      t.string :status, null: false, default: "new"

      t.timestamps
    end

    add_index :inquiries, :status
    add_index :inquiries, :created_at
  end
end
