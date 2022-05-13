require_relative '../level3/utils'

module Utils
  # Class for actions
  class Action
    attr_accessor :who, :type, :amount

    def initialize(params)
      @who = params['who']
      @type = params['type']
      @amount = params['amount']
    end

    def as_json
      {'who' => who, 'type' => type, 'amount' => amount}
    end
  end

  class Rental
    attr_accessor :actions

    # Generate data for each action related to the rental
    def generate_actions
      self.actions = []
      
      self.actions << Action.new('who' => "driver", 'type' => "debit", 'amount' => self.price)
      self.actions << Action.new('who' => "owner", 'type' => "credit", 'amount' => (self.price - self.commission.amount))
      self.actions << Action.new('who' => "insurance", 'type' => "credit", 'amount' => self.commission.insurance_fee)
      self.actions << Action.new('who' => "assistance", 'type' => "credit", 'amount' => self.commission.assistance_fee)
      self.actions << Action.new('who' => "drivy", 'type' => "credit", 'amount' => self.commission.drivy_fee)
    end

  end

  # Update the output content
  def self.build_output
    output = {'rentals' => []}

    self.rentals_list.each do |k_, rental|
      rental.calculate_commission
      rental.generate_actions

      output['rentals'] << {
        'id' => rental.id,
        'actions' => rental.actions.map(&:as_json) # Map each action to its json format
      }
    end

    output
  end
end