class PagseguroNotification < ActiveRecord::Base

   belongs_to :order

  def self.create_from_notification(notification)
    pagseguro_notification = PagseguroNotification.new

    pagseguro_notification.order          = Order.find_by_number(notification.order_id)
    pagseguro_notification.order_number   = notification.order_id
    pagseguro_notification.transaction_id = notification.transaction_id
    pagseguro_notification.status         = notification.status
    pagseguro_notification.payment_method = notification.payment_method
    pagseguro_notification.processed_at   = notification.processed_at
    pagseguro_notification.shipping_type  = notification.shipping_type
    pagseguro_notification.shipping_price = notification.shipping
    pagseguro_notification.notes          = notification.notes
    pagseguro_notification.buyer_name     = notification.buyer[:name]
    pagseguro_notification.buyer_email    = notification.buyer[:email]
    pagseguro_notification.buyer_phone    = "#{notification.buyer[:phone][:area_code]} #{notification.buyer[:phone][:number]}"

    pagseguro_notification.save
    pagseguro_notification
  end
end
