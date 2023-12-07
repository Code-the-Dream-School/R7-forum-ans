class AddDescriptionToForums < ActiveRecord::Migration[7.0]
  def change
    add_column :forums, :description, :string
  end
end
