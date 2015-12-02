class CombineItemsInCart < ActiveRecord::Migration
  def up
  	# replace multiple items in cart with a cart that only has a single type of item
  	Cart.all.each do |cart|
  		#count the number of each product in the cart
  		sums = cart.line_items.group(:product_id).sum(:quantity)
  		sums.each do |product_id, quantity|
  			if quantity > 1
  				#remove individual items
  				cart.line_items.where(product_id: product_id).delete_all
  				
  				#replace with single item
  				item = cart.line_items.build(product_id: product_id)
  				item.quantity = quantity
  				item.save!
  			end
  		end
  	end
  end

  def down
  	#split items with quantity>1 into multiple lines
  	LineItem.where("quantity>1").each do |line_item|
  		#add individual items
  		line_item.quantity.times do
  			LineItem.create cart_id: line_item.cart_id,
  			product_id: line_item.product_id, quantity: 1
  		end
  		#remove original line item
  		line_item.destroy
  	end
  end
end