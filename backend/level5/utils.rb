require_relative '../level4/utils'

module Utils
  @@options_list = Hash.new

  # Class for options
  class Option
    attr_accessor :id, :rental_id, :type

    def initialize(params)
      @id = params['id']
      @rental_id = params['rental_id']
      @type = params['type']
    end

    def fetch_rental
      Utils.rentals_list[rental_id]
    end

    def fee
      case type
      when 'gps'
        return fetch_rental.duration * 500
      when 'baby_seat'
        return fetch_rental.duration * 200
      when 'additional_insurance'
        return fetch_rental.duration * 1000
      end
    end
  end

  class Rental
    attr_accessor :options

    # Apply options related to the rental
    def add_features
      self.options = Utils.options_list.fetch(self.id, [])
    end

    # Get option fee
    def option_fee(type)
      option = self.options.select { |o| o.type == type}
      return 0 if option.empty?

      option.first.fee
    end

    def total_options_fees
      self.options.reduce(0) { |fees, o| fees + o.fee }
    end


    def owner_fees
      self.price + self.option_fee('gps') + self.option_fee('baby_seat') - self.commission.amount
    end


    # Generate data for each action related to the rental, taking into account new features
    def generate_actions
      self.actions = []
      
      self.actions << Action.new('who' => "driver", 'type' => "debit", 'amount' => (self.price + self.total_options_fees))
      self.actions << Action.new('who' => "owner", 'type' => "credit", 'amount' => self.owner_fees)
      self.actions << Action.new('who' => "insurance", 'type' => "credit", 'amount' => self.commission.insurance_fee)
      self.actions << Action.new('who' => "assistance", 'type' => "credit", 'amount' => self.commission.assistance_fee)
      self.actions << Action.new('who' => "drivy", 'type' => "credit", 'amount' => self.commission.drivy_fee + self.option_fee('additional_insurance'))
    end
    

  end

  # Update for loading the options
  def self.import_data
    json_file = File.read('./data/input.json')
    @@data = JSON.parse(json_file)

    @@data['cars'].each do |car|
      @@cars_list[car['id']] = Car.new(car)
    end

    @@data['rentals'].each do |rental|
      @@rentals_list[rental['id']] = Rental.new(rental)
    end

    @@data['options'].each do |option|
      rental_id = option['rental_id']
      @@options_list[rental_id] = [] if @@options_list[rental_id].nil?

      @@options_list[rental_id] << Option.new(option)
    end

  end

  # Return the list of options
  def self.options_list
    @@options_list
  end


  # Update the output content
  def self.build_output
    output = {'rentals' => []}

    self.rentals_list.each do |k_, rental|
      rental.calculate_commission
      rental.add_features
      rental.generate_actions

      output['rentals'] << {
        'id' => rental.id,
        'options' => rental.options.map(&:type), # Map each option to its type
        'actions' => rental.actions.map(&:as_json) # Map each action to its JSON format
      }
    end

    output
  end
end