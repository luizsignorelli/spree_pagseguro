class CreatePagseguroNotifications < ActiveRecord::Migration
  def self.up
    create_table :pagseguro_notifications do |t|
      t.integer :order_id
      t.string :order_number
      t.string :transaction_id
      t.string :status
      t.string :payment_method
      t.date :processed_at
      t.string :shipping_type
      t.decimal :shipping_price
      t.string :notes
      t.string :buyer_name
      t.string :buyer_email
      t.string :buyer_phone

      t.timestamps
    end
  end

  def self.down
    drop_table :pagseguro_notifications
  end
end
