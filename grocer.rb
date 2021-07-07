require "pry"



def consolidate_cart(cart)

  # initialize objects
  hash_output = {}
  final_cart_array = []

  # iterating over twice - once to create unique
  # final cart of items(array), and again to
  # count each item, after the [:counter] key is created
  # (?? is there a way to consolidate and only iterate ONCE ??)


  # create unique list of items, and
  # import all previous key/value pairs
  # from item's original hash(value), and
  # create a new key for counting each item

  # 1. iterate to create unique list of items,
  #    and set their [:counter] key equal to 0
  cart.each do |item_hash|
    item_name = item_hash.keys[0]
    final_cart_array << item_name
    final_cart_array = final_cart_array.uniq
    hash_output[item_name] = item_hash[item_name]
    hash_output[item_name][:count] = 0
  end

  # 2. iterate to count each item, and increase
  #    [:count] key by 1
  cart.each do |hash|
    item_called = hash.keys[0].to_s
    hash_output[item_called][:count] += 1
  end

  hash_output
end

def apply_coupons(cart, coupons)
  hash_output = cart
  cart_array = cart.keys
  coupons.each do |coupon_hash|
    original_item_name = coupon_hash[:item]

    if cart_array.include?(original_item_name)
      if hash_output[original_item_name][:count] >= coupon_hash[:num]
        new_item_name = original_item_name + " W/COUPON"

        # create new item-w/coupon hash (if does not exist)
        if hash_output.key?(new_item_name) == false
          hash_output[new_item_name] = {}
          hash_output[new_item_name][:price] = coupon_hash[:cost]
          hash_output[new_item_name][:clearance] = hash_output[original_item_name][:clearance]
          hash_output[new_item_name][:count] = 0
        end

        #change counts for original and new item
        hash_output[new_item_name][:count] += 1
        hash_output[original_item_name][:count] -= coupon_hash[:num]

      end
    end
  end
  hash_output
end

def apply_clearance(cart)
  hash_output = cart
  hash_output.each_value do |item_values|
    if item_values[:clearance] == true
      item_values[:price] = (item_values[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  total_cost = 0.0
  cart_hash = consolidate_cart(cart)
  cart_hash = apply_coupons(cart_hash, coupons)
  cart_hash = apply_clearance(cart_hash)
  cart_hash.each_value do |item_values|
    total_cost += item_values[:price] * item_values[:count]
  end

  if total_cost > 100.00
    total_cost *= 0.9
  end

  total_cost
end
