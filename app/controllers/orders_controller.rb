class OrdersController < ApplicationController
  def create
    workshop = Workshop.find(params[:workshop_id])
    order = Order.new
    order.user = current_user
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

  def create_shopping_cart_order
    stripe_json = []
    order = Order.new
    order.user = current_user
    order.state = 'pending'
    order.save
    @cart.each do |cart_item|
      product = Product.new
      product.order = order
      if cart_item.is_a?(Workshop)
        product.workshop = cart_item
        product.price_cents = cart_item.price_cents
      end
      product.save
      order.amount_cents += product.price_cents
      order.products << product
      order.save
      stripe_json << {
        price_data: {
          currency: 'usd',
          product_data: {
            name: product.workshop.shortname,
          },
          unit_amount: product.workshop.price_cents,
        },
        quantity: 1,
      }
    end

    # @text = stripe_json
    # session = Stripe::Checkout::Session.create({
    #   line_items: [{
    #     price_data: {
    #       currency: 'usd',
    #       product_data: {
    #         name: order.workshops.first.shortname,
    #       },
    #       unit_amount: order.workshops.first.price_cents,
    #     },
    #     quantity: 1,
    #   }
    # ],
    #   mode: 'payment',
    #   success_url: order_url(order),
    #   cancel_url: order_url(order),
    # })
    # stripe_json = {
    #     price_data: {
    #       currency: 'usd',
    #       product_data: {
    #         name: order.workshops.first.shortname,
    #       },
    #       unit_amount: order.workshops.first.price_cents,
    #     },
    #     quantity: 1,
    #   }

    session = Stripe::Checkout::Session.create({
      line_items: stripe_json,
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

  def to_builder
    Jbuilder.new do |product|
      product.price stripe_price_id
      product.quantity 1
    end
  end
end



#   "{
#     name: product.name,
#     description: product.description,
#     images: [product.image],
#     amount: product.amount,
#     currency: product.currency,
#     quantity: validatedQuantity,
#   },"

# "{
# price_data: {
#   currency: 'usd',
#   product_data: {
#     name: #{test},
#   },
#   unit_amount: #{amount},
# },
# quantity: 1,
# },"
