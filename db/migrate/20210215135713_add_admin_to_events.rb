class AddAdminToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :admin, index: true
  end
end
