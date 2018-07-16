class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.string :operation_type
      t.string :value
      t.references :user

      t.timestamps
    end
  end
end
