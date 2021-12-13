class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :status, :integer, default: 0
  end
end
