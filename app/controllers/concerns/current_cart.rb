module CurrentCart
	extend ActiveSupport::Concern

private
	def set_cart
		@cart = Cart.find(session[:cart_id])
	rescue ActiveRecord::RecordNotFound  #if id isn't found this creates a new cart instead of throwing and error...I think
		@cart = Cart.create
		session[:cart_id]= @cart.id
	end
end