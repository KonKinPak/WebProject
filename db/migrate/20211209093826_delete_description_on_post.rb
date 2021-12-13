class DeleteDescriptionOnPost < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :description, :text
  end
end
