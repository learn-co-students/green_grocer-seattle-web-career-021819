require 'pry'

def consolidate_cart(cart)
  consolidated_list = {}
  cart.each do |hash|
    hash.each do |item, attribute|
      if consolidated_list.has_key?(item)
        consolidated_list[item][:count] += 1
      else
        consolidated_list[item] = attribute.merge({:count => 1})
      end
    end
  end
  consolidated_list
end


def apply_coupons(cart, coupons)
  coupons_applied_cart = cart
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      coupons_applied_cart["#{name} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[name][:clearance], :count => (cart[name][:count]/coupon[:num])}
      coupons_applied_cart[name][:count] = (cart[name][:count]%coupon[:num])
    end
  end
  coupons_applied_cart
end


def apply_clearance(cart)
  cart.each do |item, attribute|
    if attribute[:clearance] == TRUE
      attribute[:price] = (attribute[:price]*0.8).round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  final_cart = consolidate_cart(cart)
  final_after_coupon = apply_coupons(final_cart, coupons)
  final_after_coupon_clearance = apply_clearance(final_after_coupon)
  total = 0
  final_after_coupon_clearance.each do |item, attribute|
    total += attribute[:price]*attribute[:count]
  end
  if total > 100
    total = (total*0.9).round(2)
  end
  total
end
