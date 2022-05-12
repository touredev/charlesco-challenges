require_relative '../level2/utils'

module Utils
  class Rental
    attr_accessor :insurance_fee, :assistance_fee, :drivy_fee

    # Compute the amount that belongs to the insurance, to the assistance and to us
    def calculate_commissions
      # We take a 30% commission on the rental price
      commission_amount = (price * 0.3).round

      # half goes to the insurance
      self.insurance_fee = (commission_amount * 0.5).round
      # 1€/day goes to the roadside assistance, 1€ == 100 cents
      self.assistance_fee = duration * 100
      # the rest goes to us
      self.drivy_fee = commission_amount - self.insurance_fee - self.assistance_fee
    end

  end

  # Update the output content
  def self.build_output
    output = {'rentals' => []}

    self.rentals_list.each do |k_, rental|
      rental.calculate_commissions
      output['rentals'] << {
        'id' => rental.id,
        'price' => rental.price,
        'commission' => { 
          'insurance_fee' => rental.insurance_fee,
          'assistance_fee' => rental.assistance_fee,
          'drivy_fee' => rental.drivy_fee
        }
      }
    end

    output
  end
end