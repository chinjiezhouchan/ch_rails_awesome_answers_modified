class AddAdminToUsers < ActiveRecord::Migration[5.2]
  # rails g migration add_admin_to_users admin:boolean
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
