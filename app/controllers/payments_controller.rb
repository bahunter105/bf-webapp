class PaymentsController < ApplicationController
  layout 'stripe_header'

  def new
    @order = current_user.orders.where(state: 'pending').find(params[:order_id])
  end
end
