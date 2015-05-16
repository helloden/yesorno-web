class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
    	t.boolean :is_yes
    	t.belongs_to :question, index: true
      t.timestamps null: false
    end
  end
end
