class OrdersController < ApplicationController
  def create
    workshop = Workshop.find(params[:workshop_id])
    # order = Order.new
    # order.user = current_user
    # order.state = 'pending'
    # order.save
    # product = Product.new
    # product.order_id = order.id
    # product.workshop_id = workshop.id
    # product.price_cents = workshop.price_cents
    # order.amount_cents = product.price_cents
    # order.save

    workshop = Workshop.first
    order = Order.new
    order.user = User.first
    order.state = 'pending'
    order.save
    product = Product.new
    product.order = order
    product.workshop = workshop
    product.price_cents = workshop.price_cents
    product.save
    order.amount_cents = product.price_cents
    order.products << product
    order.save

    # session = Stripe::Checkout::Session.create(
    #   payment_method_types: ['card'],
    #   line_items: [{
    #     name: workshop.shortname,
    #     # images: [workshop.photo_url],
    #     price: workshop.price_cents,
    #     currency: 'usd',
    #     quantity: 1
    #   }],
    #   success_url: order_url(order),
    #   cancel_url: order_url(order)
    # )
    session = Stripe::Checkout::Session.create({
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: workshop.shortname,
          },
          unit_amount: workshop.price_cents,
        },
        quantity: 1,
      }
    ],
      mode: 'payment',
      success_url: order_url(order),
      cancel_url: order_url(order),
    })




    order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(order)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
