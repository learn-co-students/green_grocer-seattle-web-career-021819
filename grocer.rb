def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |element|
    element.each do |item, item_hash|

      if consolidated_cart[item]
        consolidated_cart[item][:count] += 1
      else
        consolidated_cart[item] = item_hash
        consolidated_cart[item][:count] = 1
      end

    end
  end
  return consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|  #coupons is an array when more than 1
    couponed_item = coupon[:item]
      if cart.has_key?(couponed_item) && cart[couponed_item][:count] >= coupon[:num] #cart has coupon's item and eligible qty
        if cart["#{couponed_item} W/COUPON"]  #if the item w/coupon hash already exists
          cart["#{couponed_item} W/COUPON"][:count] += 1
        else   #create the item w coupon hash
          cart["#{couponed_item} W/COUPON"] = {}
          cart["#{couponed_item} W/COUPON"][:price] = coupon[:cost]
          cart["#{couponed_item} W/COUPON"][:clearance] = cart[couponed_item][:clearance]
          cart["#{couponed_item} W/COUPON"][:count] = 1
        end
        cart[couponed_item][:count] -= coupon[:num] #update orig cart qty
      end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, detail_hash|
    if detail_hash[:clearance] == true
      detail_hash[:price] = (detail_hash[:price] * 0.80).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)

  consolidated_cart = consolidate_cart(cart)

  couponed_cart = apply_coupons(consolidated_cart, coupons)  #Apply coupon discounts if the proper number of items are present.
#binding.pry

  discounted_cart = apply_clearance(couponed_cart)  #Apply 20% discount if items are on clearance.
#binding.pry
 price_total = 0

 discounted_cart.each do |item, details|
  #details.each do |key, value|

     price_total += details[:price] * details[:count]


 end

  if price_total > 100
    price_total = (price_total * 0.90)

  end
#If, after applying the coupon discounts and the clearance discounts, the cart's total is over $100, then apply a 10% discount.
 price_total
end
