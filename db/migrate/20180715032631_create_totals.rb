class CreateTotals < ActiveRecord::Migration[5.2]
  def change
    create_table :totals do |t|
      t.string :amount, :default => 0
      t.references :user

      t.timestamps
    end
  end
end
