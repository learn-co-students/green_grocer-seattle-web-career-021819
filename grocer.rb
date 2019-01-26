def consolidate_cart(cart)
  b = {}
	b2 = {}
	cart.each {|value|
	  if !b.has_key?(value)
	    v = value.flatten
	    key = v[0]
	    count = cart.count(value)
	    b2 = {:count => count}
	    value = value[key].merge(b2)
	    value = {key => value}
	    b = b.merge(value)
	  end
	}
	b
end

def apply_coupons(cart, coupons)
  if coupons.empty?
    return cart
  end
  receipt = {}
	a = {}
	cart.each {|cart_key, cart_values|
	  coupons.each{|coupons_values|
	    if cart_key == coupons_values[:item] && !receipt.has_key?("#{cart_key} W/COUPON")
	      cpn_string = "#{cart_key} W/COUPON"
	      cpn_item_count = 0
	      while cart_values[:count] > 0 && cart_values[:count] >= coupons_values[:num]
	        cpn_item_count += 1
	        cart_values[:count] -= coupons_values[:num]
	        a = {cpn_string => {:price => coupons_values[:cost],
	                            :clearance => cart_values[:clearance],
	                            :count => cpn_item_count}}
	      end
	      receipt = receipt.merge(a)
	      a.clear
        a = {cart_key => cart_values}
        receipt = receipt.merge(a)
	    else
	      if cart_values[:count] > 0 && !receipt.has_key?(cart_key)
	        a = {cart_key => cart_values}
	        receipt = receipt.merge(a)
	      end
	    end
	  }
	}
	receipt
end

def apply_clearance(cart)
  h = {}
	h = cart.select {|item, values|
	  if values.fetch(:clearance)
	    values[:price] *= 0.80
	    values[:price] = values[:price].round(2)
	  end
	}
	h2 = cart
	h2 = h2.delete_if {|item, value|
	  h.has_key?(item)
	}
	h = h.merge(h2)
	h
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  sum = 0
  cart.each{|cart_key, cart_values|
    sum += cart_values[:price]
  }
  sum
end
