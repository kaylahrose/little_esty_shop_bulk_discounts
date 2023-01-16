class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :bulk_discounts, :quantity, :quantity_threshold
  end
end
