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

  def create_consult_order
    order = Order.new
    order.user = current_user
    order.state = 'pending'
    order.save
    consult_product = ConsultProduct.new
    consult_product.order = order
    quantity = params[:quantity].to_i
    consult_product.quantity = quantity
    consult_product.price_cents = consult_price(quantity)
    consult_product.save
    order.amount_cents = consult_product.price_cents
    order.save
    # pry
    session = Stripe::Checkout::Session.create({
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Consultations',
          },
          unit_amount: consult_product.price_cents/consult_product.quantity,
        },
        quantity: consult_product.quantity,
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

    return nil if @order.recognized?

    user = current_user
    if @order.state == 'paid' && @order.workshops.any?
      moodle = MoodleRb.new(ENV['MOODLE_WEBSERVICES_TOKEN'], ENV['MOODLE_URL'])
      # check for user in moodle
      if user.moodle_id.nil?
        # generate password
        o = [('a'..'z'), ('A'..'Z'),%i[~ ! @ # $ % ^ & * ( ) _ +]].map(&:to_a).flatten
        moodle_password = (0...8).map { o[rand(o.length)] }.join

        moodle_user = moodle.users.create(
          :username => user.email,
          :password => moodle_password,
          :firstname => user.first_name,
          :lastname => user.last_name,
          :email => user.email,
        )
        # response {"id"=>10, "username"=>"testy2@gmail.cs"}
        user.moodle_id = moodle_user["id"]
        user.moodle_password = moodle_password
        user.save
      end

      @order.workshops.each do |workshop|
        moodle.enrolments.create(
          :user_id => user.moodle_id,
          :course_id => workshop.moodle_id,
        )
      end
    end

    if !@order.consult_products.empty? && @order.state == 'paid'
      user = @order.user
      @order.consult_products.each do |product|
        user.remaining_consultations += product.quantity
        user.save
      end
    end

    @order.recognized = true
    @order.save

  end

  def to_builder
    Jbuilder.new do |product|
      product.price stripe_price_id
      product.quantity 1
    end
  end

  def consult_price(quantity)
    if quantity >= 5
      return quantity*11999
    elsif quantity > 0
      return quantity*14999
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
