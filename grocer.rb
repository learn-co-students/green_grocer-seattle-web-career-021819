require 'pry'

def consolidate_cart(cart)
  # code here
  new_hash = {}

  cart.each do |item_hash|
    item = item_hash.keys.first
    val = item_hash.values.first

    if (new_hash[item])
      new_hash[item][:count] += 1
    else
      new_hash[item] = {:count => 1}
    end

    new_hash[item] = new_hash[item].merge(val)
    #binding.pry
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_hash = cart

  # code here
  coupons.each do |coupon|
    item = new_hash[coupon[:item]]
    if item
      if !new_hash["#{coupon[:item]} W/COUPON"]
        new_hash["#{coupon[:item]} W/COUPON"] = {:clearance => item[:clearance], :price => coupon[:cost], :count => item[:count] >= coupon[:num] ? 1 : 0}
      else
        if item[:count] >= coupon[:num] 
          new_hash["#{coupon[:item]} W/COUPON"][:count] += 1
        end
      end
      
      if item[:count] >= coupon[:num] 
        item[:count] -= coupon[:num]
      end
    end
  end
  #binding.pry
  return new_hash
end

def apply_clearance(cart)
  # code here
  cart.each do |item, item_hash|
    if item_hash[:clearance]
      item_hash[:price] = (item_hash[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0

  cart.each do |item, item_hash|
    total += item_hash[:price] * item_hash[:count]
  end

  if total > 100
    total = (total * 0.9).round(2)
  end
  
  total
end
