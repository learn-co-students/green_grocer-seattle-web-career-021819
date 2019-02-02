require 'pry'

def consolidate_cart(cart)
  grocery_hash = {}
  cart.each do |item|
    item.each do |k, v|
    if grocery_hash[k] == nil
      grocery_hash[k] = v.merge({:count => 1})
    else
      grocery_hash[k][:count] += 1
end
end
end
grocery_hash
end

def apply_coupons(cart, coupons)
final_hash = cart
coupons.each do |coupon|
  name = coupon[:item]

  if cart.keys.include?(name) && cart[name][:count] >= coupon[:num]
    final_hash["#{name} W/COUPON"] = {:price => coupon[:cost],
                                      :clearance => cart[name][:clearance],
                                      :count => (cart[name][:count]/coupon[:num])}

  final_hash[name][:count] = (cart[name][:count]%coupon[:num])


end
end
final_hash
end

def apply_clearance(cart)
  cart.each do |item, info|
    discount_amount = (info[:price] - (info[:price] * 0.20)).round(2)
    if info[:clearance] == true
    info[:price] = discount_amount
  end
end
cart
end

def checkout(cart, coupons)
  final_cart = consolidate_cart(cart)
  final_cart1 = apply_coupons(final_cart, coupons)
  final_cart2 = apply_clearance(final_cart1)
  final_amount = 0

  final_cart2.each do |k, v|
    final_amount += v[:price] * v[:count]
end

if final_amount > 100
  final_amount *= 0.9
end
final_amount
end
