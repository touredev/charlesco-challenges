require_relative '../level2/utils'

module Utils
  class Commission
    attr_accessor :amount, :rental_id, :insurance_fee, :assistance_fee, :drivy_fee

    def initialize(rental_id)
      @rental_id = rental_id
    end

    def fetch_rental
      Utils.rentals_list[rental_id.to_s]
    end

    # Compute the amount that belongs to the insurance, to the assistance and to us
    def calculate_fees
      # We take a 30% commission on the rental price
      self.amount = (fetch_rental.price * 0.3).round
      # half goes to the insurance
      self.insurance_fee = (self.amount * 0.5).round
      # 1€/day goes to the roadside assistance, 1€ == 100 cents
      self.assistance_fee = fetch_rental.duration * 100
      # the rest goes to us
      self.drivy_fee = self.amount - self.insurance_fee - self.assistance_fee
    end


    def as_json
      {'insurance_fee' => insurance_fee, 'assistance_fee' => assistance_fee, 'drivy_fee' => drivy_fee}
    end

  end

  class Rental
    attr_accessor :commission

    # Set the rental commission
    def calculate_commission
      self.commission = Commission.new(self.id) if self.commission.nil?
      self.commission.calculate_fees
    end

    def as_json
      {'id' => self.id, 'price' => self.price, 'commission' => self.commission.as_json}
    end

  end

  # Update the output content
  def self.build_output
    output = {'rentals' => []}

    self.rentals_list.each do |k_, rental|
      rental.calculate_commission
      output['rentals'] << rental.as_json
    end

    output
  end
end