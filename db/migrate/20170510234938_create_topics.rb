class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description
      t.boolean :public, default: true

      t.timestamps null: false
    end
  end
end
