def consolidate_cart(cart)
  newcart={}
  cart.each do |hashcart|
    hashcart.each do |k,v|
      if(!newcart.has_key?(k))
        newcart[k]={}
        v.each do |k2, v2|
          newcart[k][k2]=v2
        end
        newcart[k][:count]=1
      else
        newcart[k][:count]+=1
      end
    end
  end
  newcart
end

def apply_coupons(cart, coupons)
  newcart= {}
  coupons.each do |save|
    word=save[:item]
    #check=false
    if cart.has_key?(word)
      if cart[word][:count]-save[:num]>=0
        cart[word][:count]-=save[:num]
      end
      newword="#{word} W/COUPON"
      if !newcart.has_key?(newword)
        newcart[newword]={price: save[:cost],
        clearance: cart[word][:clearance], count: 1}
      else
          newcart[newword][:count]+=1
      end
    end
  end
  newcart.merge(cart)
end
  

def apply_clearance(cart)
  #sick example of map on a hash
  a=cart.map do |k, v|
    if v[:clearance]
      num=(v[:price]* 0.8).round(3)
      v[:price] =num
    end
    [k,v]
  end.to_h
end

def checkout(cart, coupons)
  p coupons
    puts ""
  p cart
    puts ""
  newcart=apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  p newcart
  total=0.0
  newcart.each do |k, v|
    if (k.include?("COUPON"))
      total+=v[:price]
    else
    total += v[:price]*v[:count]
    end
  end
  if total>100
    total*=0.9
  end
  total
end
