require_relative '../level1/utils'

module Utils
  class Rental

     # Compute the duration price based on the new rules
     def duration_price
      price_per_day = fetch_car.price_per_day
      discounted_price = price_per_day

      case duration
      when 1
        discounted_price = price_per_day
      when 2..4
        # price per day decreases by 10% after 1 day
        discounted_price = price_per_day # first day price
        discounted_price += (duration - 1) * (price_per_day * 0.9).round # remaining days
      when 5..10
        # price per day decreases by 30% after 4 days
        discounted_price = price_per_day # first day price
        discounted_price += (3 * (price_per_day * 0.9).round) # 3 days after the first day
        discounted_price += ((duration - 4) * (price_per_day * 0.7).round) # remaining days
      else
        # price per day decreases by 50% after 10 days
        discounted_price = price_per_day # first day price
        discounted_price += (3 * (price_per_day * 0.9).round) # 3 days after the first day
        discounted_price += (6 * (price_per_day * 0.7).round) # 6 days after the first 4 days
        discounted_price += ((duration - 10) * (price_per_day * 0.5).round) # remaining days
      end

      discounted_price
    end

  end
end