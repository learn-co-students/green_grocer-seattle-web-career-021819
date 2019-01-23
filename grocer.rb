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
  c_a = []
	c = {}
	coupons.each{|value|
	  count = coupons.count(value)
	  c = {:count => count}
	  c_a << value.merge(c)
	}
	c_a.uniq!
	c_h = {}
	c = {}
	cart.each {|cart_item, cart_values|
	  c_a.each {|coupon_value|
	    if coupon_value[:item] == cart_item
	      coupon_count = 0
	      while cart_values[:count] >= coupon_value[:num] && coupon_value[:count] > 0
	        string_item = "#{cart_item} W/COUPON"
	        coupon_count += 1
	        c = {string_item => {:price => coupon_value[:cost],
	                    :clearance => cart_values[:clearance],
	                    :count => coupon_count}}
	        cart_values[:count] -= coupon_value[:num]
	        coupon_value[:count] -= 1
	      end
	    else
	      c = {cart_item => cart_values}
	    end
	    c_h = c_h.merge(c)
	  }
	}
	c_h
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
  # code here
end
