class ChargesController < ApplicationController

	def new

	end

	def create
	  # Amount in cents
	 

	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :description => 'Rails Stripe customer',
	    :currency    => 'gbp',
	    :amount => 499
	  )

	purchase = Purchase.create(email: params[:stripeEmail], card: params[:stripeToken], 
	  	amount: params[:amount], description: charge.description, currency: charge.currency,
	  	customer_id: customer.id, product_id: 1, uuid: SecureRandom.uuid)

	redirect_to purchase

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_charge_path
	end

end