def consolidate_cart(cart)
  cart_hash = {}
  item_name_arr = []

  cart.each do |x|
    x.each do |item_name, details|
      item_name_arr << item_name # cart.count(x)
      cart_hash[item_name] = details
      cart_hash[item_name][:count] = item_name_arr.count(item_name)
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  new_cart = {}
  #coupon_counter = 0
  coupon_counter = {}

  cart.each do | item_name, details|
    new_cart[item_name] = details
    coupon_counter[item_name] = 0
  end

  cart.each do |item_name, details|
    coupons.each do |x|
      if (item_name == x[:item] && details[:count] >= x[:num])
          new_cart["#{item_name} W/COUPON"] = {}
          new_cart["#{item_name} W/COUPON"][:price] = x[:cost]
          new_cart["#{item_name} W/COUPON"][:clearance] = details[:clearance]
            until details[:count] < x[:num]
              details[:count] = details[:count] - x[:num]
              coupon_counter[item_name] +=1
            end
          new_cart["#{item_name} W/COUPON"][:count] = coupon_counter[item_name]
        end
      end
    end
  new_cart
end

def apply_clearance(cart)
  clearance_cart = {}
  cart.each do | item_name, details|
    clearance_cart[item_name] = details
  end

  cart.each do |item_name, details|
    if details[:clearance] == true
      clearance_cart[item_name][:price] = (details[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  coupon_cart = consolidate_cart(cart)
  clearance_cart = apply_coupons(coupon_cart,coupons)
  checkout_cart = apply_clearance(clearance_cart)

  # calculate_total_cost of checkcart
  total_bill = 0
  checkout_cart.each do |item_name, details|
    item_total = details[:price] * details[:count]
    total_bill += item_total
  end
  if total_bill > 100
    total_bill = (total_bill * 0.9).round(2)
  end
  total_bill
end
