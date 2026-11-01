class AddCoverCreditToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :cover_credit, :string
    add_column :posts, :cover_credit_url, :string
  end
end
