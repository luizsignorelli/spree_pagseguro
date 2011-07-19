# encoding: utf-8
class PagseguroController < Spree::BaseController
  skip_before_filter :verify_authenticity_token

  respond_to :html

  def notify
    show_order_summary_and_pagseguro_message() and return if !request.post?

    pagseguro_notification do |notification|
      @order = Order.find_by_number(notification.order_id)
      create_payment()
      PagseguroNotification.create_from_notification(notification)
      process_pagseguro_notification(notification)
    end
    render :nothing => true
  end

  private

  def show_order_summary_and_pagseguro_message
    @order = current_order
    complete_order()
    flash[:notice] = "Seu pedido foi processado com sucesso e estamos aguardando a confirmação do pagamento junto ao PagSeguro. Você será informado através do seu email sobre o andamento do pedido."
    session[:order_id] = nil
    session[:wedding_list_id] = nil
    redirect_to order_path(@order)
  end

  def create_payment
    if @order.payments.empty?
      payment = @order.payments.create(:amount => @order.total, :payment_method_id => @order.payment_method.id)
      payment.started_processing!
    end
  end

  def complete_order
    until @order.state == "complete"
      @order.next
    end
  end

  def process_pagseguro_notification(notification)
    if notification.status == :completed or notification.status == :approved
      @order.payment.complete!
    elsif notification.status == :pending or notification.status == :verifying
      @order.payment.pend!
    elsif notification.status == :canceled or notification.status == :refunded
      @order.payment.started_processing!
      @order.payment.fail!
      @order.cancel!
    end
  end

end