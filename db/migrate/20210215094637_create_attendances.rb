class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
      t.string :stripe_customer_id
    end
  end
end
