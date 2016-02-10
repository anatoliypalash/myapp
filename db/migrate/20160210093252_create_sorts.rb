class CreateSorts < ActiveRecord::Migration
  def change
    create_table :sorts do |t|
      t.belongs_to :user, index: true
      t.integer :sort_user_id
      t.integer :sort_order
    end
  end
end
